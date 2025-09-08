# frozen_string_literal: true

require_relative 'file'
require 'debug'
require 'optparse'

DEFAULT_COLUMN_COUNT = 3
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
  list = false
  opt.on('-a') { |v| all = v }
  opt.on('-r') { |v| reverse = v }
  opt.on('-l') { |v| list = v }
  paths = opt.parse(arguments)
  { all:, reverse:, list:, paths: }
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

def get_files(path, all, reverse)
  flags = all ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags, base: path).map do |file_name|
    file_path = path + file_name
    LS::File.new(file_name, file_path)
  end
  exit_if_file_not_found if files.empty?
  files.reverse! if reverse
  files
end

def print_files(files, list)
  if list
    list_files = build_files(files, column_count: 1)
    list_widths = calculate_list_width(files)
    puts "total #{calculate_total_blocks(files)}"
    list_files.each do |files|
      files.compact.each do |file|
        print list_output(file, list_widths)
      end
      puts ''
    end
  else
    default_files = build_files(files)
    default_widths = calculate_default_width(files)
    default_files.each do |files|
      files.compact.each do |file|
        print default_output(file, default_widths)
      end
      puts ''
    end
  end
end

def build_files(files, column_count: DEFAULT_COLUMN_COUNT)
  row_count = files.size < column_count ? 1 : files.size.ceildiv(column_count)
  copy_files = files.map { |file| file }
  rows = Array.new(row_count) { [] }
  column_count.times do
    row_count.times do |row_number|
      rows[row_number].push(copy_files.shift)
    end
  end
  rows
end

def calculate_list_width(files)
  widths = Hash.new { |hash, key| hash[key] = [] }
  files.each do |f|
    widths[:owner].push(f.owner.name.length)
    widths[:group].push(f.group.name.length)
    widths[:nlink].push(f.nlink.length)
    widths[:size].push(f.size.length)
    widths[:mtime].push(f.mtime.length)
    widths[:name].push(f.name.length)
  end
  widths.transform_values { |widths| widths.max + 1 }
end

def calculate_default_width(files)
  longest_filename_length = files.map { |f| f.name.length }.max
  { name: longest_filename_length + 2 }
end

def calculate_total_blocks(files)
  # rubyが求めるブロックサイズは１ブロックが512バイト、Linuxのlsは１ブロックを1024で計算しているため、２で割っている
  files.map { |file| file.blocks.div(2) }.sum
end

def check_file_type(file)
  return :directory if file.directory?
  return :symlink if file.symlink? && File.exist?(file.path)
  return :broken if file.symlink? && !File.exist?(file.path)
  return :exe if file.executable?

  :file
end

def default_output(file, widths)
  file_type = check_file_type(file)
  "\e[#{COLORS[file_type]}#{file.name.ljust(widths[:name])}\e[0m"
end

def list_output(file, widths)
  file_type = check_file_type(file)
  output = <<~OUTPUT
    #{file.str_mode}#{file.nlink.rjust(widths[:nlink])}
    #{file.owner.name.rjust(widths[:owner])}
    #{file.group.name.rjust(widths[:group])}
    #{file.size.rjust(widths[:size])}
    #{file.mtime.rjust(widths[:mtime])}
     \e[#{COLORS[file_type]}#{file.name.ljust(widths[:name])}\e[0m
  OUTPUT
  output.delete("/\n/")
end
