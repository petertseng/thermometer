class InconclusiveException < Exception; end

class ContradictionException < Exception; end

class Thermometer
  alias Coordinate = Tuple(UInt32, UInt32)
  alias Cell = Tuple(UInt32, UInt32)
  alias ThermometerID = UInt32

  @cells_left : UInt32
  @cell_width : UInt32
  @left_width : UInt32
  @grid : Array(Array(Cell))
  @thermometers = Hash(ThermometerID, Array(Coordinate)).new { |h, k| h[k] = [] of Coordinate }

  def initialize(@cols : Array(Int32), @rows : Array(Int32), @grid = Array(Array(Cell)), @verbose : Bool = false)
    @states = Array(Array(Bool?)).new(@rows.size) { Array(Bool?).new(@cols.size, nil) }
    @change = Array(Array(Bool)).new(@rows.size) { Array(Bool).new(@cols.size, false) }
    @cell_width = @grid.map { |r| r.map { |t, x| "#{t}.#{x}".size }.max }.max.to_u32
    @left_width = @rows.map { |c| c ? c.to_s.size : 1 }.max.to_u32
    @cells_left = (@cols.size * @rows.size).to_u32
    @grid.each_with_index { |row, y|
      y = y.to_u32
      row.each_with_index { |(thermometer, pos), x|
        until @thermometers[thermometer].size >= pos
          # Eh, any invalid coordinate
          @thermometers[thermometer] << {@rows.size.to_u32, @cols.size.to_u32}
        end
        @thermometers[thermometer][pos - 1] = {y, x.to_u32}
      }
    }
  end

  def solve(may_guess : Bool = true)
    until @cells_left == 0
      col_state = ->(n : UInt32) { @states.map { |s| s[n] } }
      col_coord = ->(mine : UInt32, theirs : UInt32) { {theirs, mine} }
      row_state = ->(n : UInt32) { @states[n] }
      row_coord = ->(mine : UInt32, theirs : UInt32) { {mine, theirs} }

      cols = infer(@cols, "Col", col_state, col_coord)
      rows = infer(@rows, "Row", row_state, row_coord)

      if !cols && !rows
        if may_guess
          success = false
          # single cell guess is OK to emulate a human, and is sufficient for all.
          # Maybe let the caller configure to use it.
          success ||= single_cell_guess
          # Hasn't been a puzzle that needed a group infer, but it's fun to watch.
          # But no human would have time to do these!
          success ||= group_guess
          raise InconclusiveException.new unless success
        else
          raise InconclusiveException.new
        end
      end
    end
    @states.map(&.dup).to_a
  end

  def to_s
    header = (" " * (@left_width + 1)) + @cols.map { |c| "%#{@cell_width}s" % (c || '-') }.join(" ")
    header + "\n" + @rows.zip(@states).map_with_index { |(n, row), y|
      ("%#{@left_width}s " % (n || '-')) + row.map_with_index { |c, x|
        colour =
          case c
          when true ; 32
          when false; 31
          else        0
          end
        "\e[#{@change[y][x] ? 1 : 0};#{colour}m#{"%#{@cell_width}s" % ("%d.%d" % @grid[y][x])}\e[0m"
      }.join(" ")
    }.join("\n")
  end

  private def make_guess
    was_verbose = @verbose
    @verbose = false
    cells_left = @cells_left

    # It's important we replace @states with a new array
    # (rather than simply save it, let it be overwritten,
    # and then restore it)
    # since someone may be iterating over it.
    # (Okay, not in this code, but other code)
    save_state = @states
    @states = @states.map(&.dup)

    begin
      yield
      solve(may_guess: false)
      @states.map(&.dup)
    rescue e : InconclusiveException
      # On an inconclusive, give the resulting state.
      # On a conflict, let the caller handle it.
      @states.map(&.dup)
    ensure
      @states = save_state
      @cells_left = cells_left
      @verbose = was_verbose
    end
  end

  alias Positions = NamedTuple(grid: UInt32, thermometer: ThermometerID)

  private def group_targets(n : Int32, my_index : UInt32, size : Int32, name : String, states : UInt32 -> Array(Bool?), coord : UInt32, UInt32 -> Coordinate) : Tuple(Int32, Int32, Hash(ThermometerID, Array(Positions)))
    my_states = states.call(my_index)

    target_trues = n
    target_falses = size - n
    candidates = Hash(ThermometerID, Array(Positions)).new { |h, k| h[k] = [] of Positions }
    my_states.each_with_index { |cs, i|
      i = i.to_u32
      c = coord.call(my_index, i)
      thermometer_id, pos_in_thermometer = @grid[c[0]][c[1]]
      if cs.nil?
        candidates[thermometer_id] << {grid: i, thermometer: pos_in_thermometer}
      elsif cs
        raise ContradictionException.new("#{name} #{my_index} has too many true") if target_trues == 0
        target_trues -= 1
      else
        raise ContradictionException.new("#{name} #{my_index} has too many false") if target_falses == 0
        target_falses -= 1
      end
    }

    {target_trues, target_falses, candidates}
  end

  private def infer(group : Array(Int32), name : String, states : UInt32 -> Array(Bool?), coord : UInt32, UInt32 -> Coordinate) : Bool
    group.map_with_index { |n, my_index|
      my_index = my_index.to_u32
      target_trues, target_falses, candidates = group_targets(n, my_index, group.size, name, states, coord)

      changed_thermometers = [] of ThermometerID

      candidates.each { |thermometer_id, thermometer_candidates|
        thermometer_candidates.sort_by! { |x| x[:thermometer] }
        if thermometer_candidates.size > target_falses
          diff = thermometer_candidates.size - target_falses
          puts "#{name} #{my_index} (#{n}) has only #{target_falses} false left: Thermometer #{thermometer_id} first #{diff} are true" if @verbose
          thermometer_candidates.first(diff).each { |x|
            self[coord.call(my_index, x[:grid])] = true
          }
          changed_thermometers << thermometer_id
        end
        if thermometer_candidates.size > target_trues
          diff = thermometer_candidates.size - target_trues
          puts "#{name} #{my_index} (#{n}) has only #{target_trues} true left: Thermometer #{thermometer_id} last #{diff} are false" if @verbose
          thermometer_candidates.last(diff).each { |x|
            self[coord.call(my_index, x[:grid])] = false
          }
          changed_thermometers << thermometer_id
        end
      }

      check_thermometers(changed_thermometers)

      if @verbose && !changed_thermometers.empty?
        puts self.to_s
        # Don't need to bother clearing change if not verbose.
        @change.each { |c| c.fill(false) }
      end

      !changed_thermometers.empty?
    }.any?
  end

  private def single_cell_guess : Bool
    choices = [] of Tuple(Coordinate, Bool)
    nils = {} of Coordinate => Int32

    @states.each_with_index { |row, y|
      y = y.to_u32
      row.each_with_index { |state, x|
        x = x.to_u32
        next unless state.nil?
        [true, false].each { |guess|
          begin
            guess_state = make_guess {
              @states[y][x] = guess
              check_thermometers([@grid[y][x][0]])
            }
            nils[{y, x}] = guess_state.map(&.count(nil)).sum
          rescue e : ContradictionException
            choices << { {y, x}, !guess }
          end
        }
      }
    }

    if @verbose
      current_nils = @states.map(&.count(nil)).sum
      choices.each { |(coord, guess)|
        puts "#{coord} -> #{!guess} causes contradiction. #{guess} reveals #{current_nils - nils[coord]} / #{current_nils} cells."
      }
      puts "#{choices.size} / #{@states.map(&.count(nil)).sum} cells cause contradictions."
    end

    return false if choices.empty?

    most_useful = choices.min_by { |(coord, _)| nils[coord] }
    if @verbose
      num_most_useful = choices.count { |(coord, _)| nils[coord] == nils[most_useful[0]] }
      puts "#{num_most_useful} are the most useful."
    end
    self[most_useful[0]] = most_useful[1]
    check_thermometers([@grid[most_useful[0][0]][most_useful[0][1]][0]])

    if @verbose
      puts self.to_s
      # Don't need to bother clearing change if not verbose.
      @change.each { |c| c.fill(false) }
    end

    true
  end

  private def group_guess : Bool
    col_state = ->(n : UInt32) { @states.map { |s| s[n] } }
    col_coord = ->(mine : UInt32, theirs : UInt32) { {theirs, mine} }
    row_state = ->(n : UInt32) { @states[n] }
    row_coord = ->(mine : UInt32, theirs : UInt32) { {mine, theirs} }

    candidates = group_infer(@cols, "Col", col_state, col_coord).to_a + group_infer(@rows, "Row", row_state, row_coord).to_a
    return false if candidates.empty?

    # Even the smallest sets have a lot anyway, so a human wouldn't have been able to do this anyway.
    winner = candidates.min_by { |l| l[5] }
    # Most impact, which is hopefully the entire board.
    #winner = candidates.max_by(&.last.size)

    name, possible, trues, cells, combinations, total, changes = winner

    changes.each { |coord, v|
      self[coord] = v
    }

    if @verbose
      puts "#{name}: There are #{possible} possible ways / #{total} (#{cells} C #{trues}): #{combinations}. They collectively force #{changes.size} cells"
      puts self.to_s
      # Don't need to bother clearing change if not verbose.
      @change.each { |c| c.fill(false) }
    end
    true
  end

  # Too lazy to type the return type
  private def group_infer(group : Array(Int32), name : String, states : UInt32 -> Array(Bool?), coord : UInt32, UInt32 -> Coordinate)
    group.each_with_index.compact_map { |(n, my_index)|
      my_index = my_index.to_u32
      target_trues, target_falses, candidates = group_targets(n, my_index, group.size, name, states, coord)

      cells = candidates.values.flatten
      possible_states = [] of Array(Array(Bool?))
      possible_combinations = [] of Array(Coordinate)
      total_combinations = 0

      cells.each_combination(target_trues) { |try_trues|
        total_combinations += 1
        try_falses = cells - try_trues
        begin
          possible_states << make_guess {
            try_trues.each { |t|
              c = coord.call(my_index, t[:grid])
              self[c] = true
            }
            try_falses.each { |t|
              c = coord.call(my_index, t[:grid])
              self[c] = false
            }
            check_thermometers(candidates.keys)
          }
          possible_combinations << try_trues.map { |t| coord.call(my_index, t[:grid]) }
        rescue e : ContradictionException
          # Do nothing
        end
      }

      changes = [] of Tuple(Coordinate, Bool)
      @states.each_with_index { |row, y|
        y = y.to_u32
        row.each_with_index { |state, x|
          x = x.to_u32
          next unless state.nil?
          possible_1 = possible_states.first[y][x]
          next if possible_1.nil?
          changes << { {y, x}, possible_1 } if possible_states.all? { |ps| ps[y][x] == possible_1 }
        }
      }

      next nil if changes.empty?

      {"#{name} #{my_index}", possible_states.size, target_trues, cells.size, possible_combinations, total_combinations, changes}
    }
  end

  def [](c : Coordinate) : Bool?
    y, x = c
    @states[y][x]
  end

  private def []=(c : Coordinate, v : Bool)
    y, x = c
    current_value = @states[y][x]
    if current_value.nil?
      @cells_left -= 1
      @change[y][x] = true
    elsif v != current_value
      raise ContradictionException.new("#{v} conflicts with #{current_value} at #{y}, #{x}")
    end
    @states[y][x] = v
  end

  private def check_thermometers(thermometers)
    thermometers.each { |id|
      thermometer = @thermometers[id]
      thermometer.each_cons(2).with_index { |(a, b), i|
        if self[a] == false && self[b].nil?
          puts "Thermometer #{id} after #{i + 1} are all false" if @verbose
          thermometer[(i + 1)..-1].each { |c| self[c] = false }
          break
        end
        raise ContradictionException.new("Thermometer #{id} #{i + 1} is false, but thermometer #{id} #{i + 2} is true") if self[a] == false && self[b]
      }
      thermometer.reverse.each_cons(2).with_index { |(a, b), i|
        if self[a] && self[b].nil?
          puts "Thermometer #{id} before #{thermometer.size - i} are all true" if @verbose
          thermometer[0...(-i - 1)].each { |c| self[c] = true }
          break
        end
      }
    }
  end
end
