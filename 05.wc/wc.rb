# frozen_string_literal: true

require 'optparse'

def get_option_and_paths(arguments)
  line = false
  word = false
  byte = false
  opt = OptionParser.new
  opt.on('-l') { |v| line = v }
  opt.on('-w') { |v| word = v }
  opt.on('-c') { |v| byte = v }
  paths = opt.parse(arguments)
  if !line && !word && !byte
    { line: true, word: true, byte: true, paths: }
  else
    { line:, word:, byte:, paths: }
  end
end

def build_stdin_output
  input = STDIN.read
  outputs = {
    line: input.lines.count,
    word: input.split.count,
    byte: input.size,
  }
end

def build_file_output(path)
  begin
    outputs = {
      line: File.read(path).lines.count,
      word: File.read(path).split.count,
      byte: File.size(path),
      name: path,
    }
  rescue Errno::ENOTDIR
    outputs = {
      error: "wc: #{path}: Not a directory",
    }
  rescue Errno::ENOENT
    outputs = {
      error: "wc: #{path}: No such file or directory",
    }
  end
end

def build_directory_output(path)
  outputs = {
    message: "wc: #{path}: Is a directory\n",
    line: 0,
    word: 0,
    byte: 0,
    name: path
  }
end

def calculate_total(totals, outputs)
  return totals if outputs.key?(:error)
  totals[:line] += outputs[:line]
  totals[:word] += outputs[:word]
  totals[:byte] += outputs[:byte]
  totals
end

def display(outputs, flags)
  outputs.each do |key, value|
    if flags[key]
      print "#{value} "
    end
  end
  puts ''
end

def display_totals(totals, flags)
  totals[:name] = 'total'
  display(totals, flags)
end

get_option_and_paths(ARGV) => { line:, word:, byte:, paths: }
totals = Hash.new { |h, k| h[k] = 0 }
output_flags = { line:, word:, byte:, name: true, message: true, error: true}
if paths.empty?
  stdins = build_stdin_output
  display(stdins, output_flags)
else
  paths.each do |path|
    outputs = {}
    if File.directory?(path)
      outputs = build_directory_output(path)
    else
      outputs = build_file_output(path)
      totals = calculate_total(totals, outputs)
    end
    display(outputs, output_flags)
  end
  display_totals(totals, output_flags) if paths.length > 1
end
