# frozen_string_literal: true

require_relative 'file'

def exit_if_not_exist(path)
  puts "ls: cannot access '#{path}': No such file or directory"
  exit(1)
end

def exit_file_is_ture(path)
  puts path
  exit(0)
end

def exit_if_file_not_found
  puts 'ディレクトリが空です'
  exit(0)
end

def get_files(path)
  Dir.glob('*', base: path).map do |file_name|
    LS::File.new(file_name, File::Stat.new(path + file_name))
  end
end

def build_files(files)
  number_of_columns = 3
  number_of_rows = files.size < number_of_columns ? 1 : (files.size.to_f / number_of_columns).ceil
  rows = Array.new(number_of_rows) { [] }
  number_of_columns.times do
    number_of_rows.times do |row_number|
      rows[row_number].push(files.shift)
    end
  end
  rows
end

def calculation_output_width(build_files)
  file_names = build_files.flatten.compact.map(&:name)
  max_length = file_names.max_by(&:length).length
  max_length + 2
end

def print_files(build_files)
  output_width = calculation_output_width(build_files)
  build_files.each do |files|
    files.compact.each do |file|
      output = file.name.ljust(output_width)
      print file.directory? ? "\e[34m#{output}\e[0m" : output
    end
    puts ''
  end
end

