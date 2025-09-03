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

def get_files(path, all)
  flags = all ? File::FNM_DOTMATCH : 0
  Dir.glob('*', flags, base: path).map do |file_name|
    file_path = path + file_name
    LS::File.new(file_name, file_path)
  end
end

def build_files(list, files)
  number_of_columns = list ? 1 : DEFAULT_COLUMN_COUNT
  number_of_rows = files.size < number_of_columns ? 1 : files.size.ceildiv(number_of_columns)
  rows = Array.new(number_of_rows) { [] }
  number_of_columns.times do
    number_of_rows.times do |row_number|
      rows[row_number].push(files.shift)
    end
  end
  rows
end

def get_widths_and_puts_total(list, files)
  if list
    total_blocks = calculate_total_blocks(files)
    puts "total #{total_blocks}"
    calculate_list_width(files)
  else
    calculate_default_width(files)
  end
end

def calculate_list_width(files)
  widths = {
    owner: [],
    group: [],
    nlink: [],
    size: [],
    mtime: [],
    name: [],
  }
  # それぞれの処理の結合度を落とす目的で冗長にしている
  files.each do |f|
    widths[:owner].push(f.owner.name.length)
    widths[:group].push(f.group.name.length)
    widths[:nlink].push(f.nlink.length)
    widths[:size].push(f.size.length)
    widths[:mtime].push(f.mtime.length)
    widths[:name].push(f.name.length)
  end
  widths.transform_values { |widths| widths.max }
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
  if file.directory?
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

def print_files(build_files, list, widths)
  build_files.each do |files|
    files.compact.each do |file|
      if list
        print list_output(file, widths)
      else
        print default_output(file, widths)
      end
    end
    puts ''
  end
end
