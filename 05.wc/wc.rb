# frozen_string_literal: true

require 'optparse'

def main
  column_names, paths = column_names_and_paths
  statistics_matrix =
    if paths.empty?
      [build_statistics_row(input: $stdin.read)]
    else
      build_statistics_matrix(paths)
    end
  width = calculate_output_width(statistics_matrix, column_names)
  statistics_matrix.each do |statistics|
    render(statistics, column_names, width)
  end
end

def column_names_and_paths
  line = false
  word = false
  size = false
  opt = OptionParser.new
  opt.on('-l') { |v| line = v }
  opt.on('-w') { |v| word = v }
  opt.on('-c') { |v| size = v }
  paths = opt.parse(ARGV)
  column_names =
    if [line, word, size].none?
      %i[line_count word_count size]
    else
      { line_count: line, word_count: word, size: size }.map do |option, flag|
        option if flag
      end.compact
    end
  [column_names, paths]
end

def build_statistics_row(input:, name: nil)
  {
    line_count: input.lines.count,
    word_count: input.split.count,
    size: input.size,
    name: name
  }
end

def build_statistics_matrix(paths)
  statistics_matrix = paths.map do |path|
    build_statistics_row( File.read(path),  path)
  end
  if statistics_matrix.length > 1
    statistics_matrix + [calculate_total(statistics_matrix)]
  else
    statistics_matrix
  end
end

def calculate_total(statistics_matrix)
  line_count_sum = 0
  word_count_sum = 0
  size_sum = 0
  statistics_matrix.each do |statistics|
    line_count_sum += statistics[:line_count]
    word_count_sum += statistics[:word_count]
    size_sum += statistics[:size]
  end
  { line_count: line_count_sum, word_count: word_count_sum, size: size_sum, name: 'total' }
end

def calculate_output_width(statistics_matrix, column_names)
  widths = statistics_matrix.map do |statistics|
    column_names.map do |column_name|
      statistics[column_name].to_s.length
    end
  end
  widths.flatten.max
end

def render(statistics, column_names, width)
  column_names.each do |column_name|
    print "#{statistics[column_name].to_s.rjust(width)} "
  end
  print statistics[:name]
  puts ''
end

main
