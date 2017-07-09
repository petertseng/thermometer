(1..30).each { |n|
  id = '%03d' % n.to_i
  lines = `curl http://www.janko.at/Raetsel/Thermometer/#{id}.a.htm`.lines
  File.open(id, ?w) { |f|
    print = false
    lines.each { |l|
      print ||= l.chomp == 'clabels'
      print &&= l.chomp != 'solution'
      f.puts l.chomp if print
    }
  }
  Kernel.sleep(1)
}