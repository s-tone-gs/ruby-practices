# frozen_string_literal: true

require_relative 'file'
require 'debug'
require 'optparse'

NUMBER_OF_COLUMNS = 3
COLORS = {
  directory: '34m',
  symlink: '96m',
  broken: '91m',
  exe: '92m',
  file: '37m'
}.freeze

def option_and_path(arguments)
  opt = OptionParser.new
  all = false
  reverse = false
  opt.on('-a') { |v| all = v }
  opt.on('-r') { |v| reverse = v }
  paths = opt.parse(arguments)
  { all: all, reverse: reverse, path: paths }
end

def exit_if_not_exist(path)
  puts "ls: cannot access '#{path}': No such file or directory"
  exit(1)
end

def exit_file_is_true(path)
  puts path
  exit(0)
end

def exit_if_file_not_found
  puts 'ディレクトリが空です'
  exit(0)
end

def get_files(path, all)
  flags = all ? File::FNM_DOTMATCH : 0
  Dir.glob('*', flags, base: path).map do |file_name|
    file_path = path + file_name
    LS::File.new(file_name, file_path)
  end
end

def build_files(files)
  number_of_rows = files.size < NUMBER_OF_COLUMNS ? 1 : files.size.ceildiv(NUMBER_OF_COLUMNS)
  rows = Array.new(number_of_rows) { [] }
  NUMBER_OF_COLUMNS.times do
    number_of_rows.times do |row_number|
      rows[row_number].push(files.shift)
    end
  end
  rows
end

def calculation_output_width(build_files)
  longest_filename_length = build_files.flatten.compact.map { |f| f.name.length }.max
  longest_filename_length + 2
end

def prepare_output(file, width)
  file_type = if file.directory?
                :directory
              elsif file.symlink?
                if File.exist?(file.path)
                  :symlink
                else
                  :broken
                end
              elsif file.executable?
                :exe
              else
                :file
              end
  "\e[#{COLORS[file_type]}#{file.name.ljust(width)}\e[0m"
end

def print_files(build_files)
  output_width = calculation_output_width(build_files)
  build_files.each do |files|
    files.compact.each do |file|
      print prepare_output(file, output_width)
    end
    puts ''
  end
end
