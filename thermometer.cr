require "./src/thermometer"

test = ARGV.delete("-t")

lines = ARGF.each_line.to_a
cols = lines[1].split.map(&.to_i)
rows = lines[3].split.map(&.to_i)
board = lines[5...(5 + rows.size)].map(&.split.map(&.split('.').map(&.to_u32)).map { |(x, y)| {x, y} })

if test
  puts cols
  puts rows
  # Output board suitable for testing.
  board.each { |row|
    puts "[" + row.map { |(t, i)| "{#{t}_u32, #{i}_u32}" }.join(", ") + "],"
  }
end

solved = Thermometer.new(cols, rows, board, verbose: !test).solve

solved.each { |x| puts x.to_s + "," } if test
