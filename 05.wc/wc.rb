# frozen_string_literal: true

require 'optparse'

def main
  get_option_and_paths(ARGV) => { line:, word:, byte:, paths: }
  totals = { line: 0, word: 0, byte: 0 }
  output_flags = { line:, word:, byte: }
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
end

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
  input = $stdin.read
  {
    line: input.lines.count,
    word: input.split.count,
    byte: input.size
  }
end

def build_file_output(path)
  content = File.read(path)
  {
    line: content.lines.count,
    word: content.split.count,
    byte: content.size,
    name: path
  }
rescue Errno::ENOTDIR
  {
    error: "wc: #{path}: Not a directory"
  }
rescue Errno::ENOENT
  {
    error: "wc: #{path}: No such file or directory"
  }
end

def build_directory_output(path)
  {
    message: "wc: #{path}: Is a directory\n",
    line: 0,
    word: 0,
    byte: 0,
    name: path
  }
end

def calculate_total(totals, outputs)
  return totals if outputs.key?(:error)

  totals.each_with_object({}) do |(key, value), hash|
    hash[key] = value + outputs[key]
  end
end

def adjust_style(output, key)
  str_output = output.to_s
  width = str_output.length + 1
  return str_output.rjust(width) if key == :line || :word || :byte

  str_output.ljust(width)
end

def display(outputs, flags)
  filtered_outputs = outputs.reject do |key|
    (key == :line && !flags[:line]) ||
      (key == :word && !flags[:word]) ||
      (key == :byte && !flags[:byte])
  end
  filtered_outputs.each do |key, value|
    print adjust_style(value, key)
  end
  puts ''
end

def display_totals(totals, flags)
  totals[:name] = 'total'
  display(totals, flags)
end

main
