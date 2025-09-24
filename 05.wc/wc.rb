# frozen_string_literal: true

require 'optparse'
require 'debug'

def main
  paths, option_flags = option_and_paths
  text_metadata_collection =
    if paths.empty?
      [create_text_metadata(option_flags, input: $stdin.read)]
    else
      build_text_metadata(paths, option_flags)
    end
  width = calculate_output_width(text_metadata_collection)
  text_metadata_collection.each do |text_metadata|
    render(text_metadata, width)
  end
end

def option_and_paths
  line = false
  word = false
  size = false
  opt = OptionParser.new
  opt.on('-l') { |v| line = v }
  opt.on('-w') { |v| word = v }
  opt.on('-c') { |v| size = v }
  paths = opt.parse(ARGV)
  if !line && !word && !size
    [ paths, { line: true, word: true, size: true} ]
  else
    [ paths, { line:, word:, size:, paths: } ]
  end
end

def create_text_metadata(option_flags, input: , name: nil)
  {
    line_count: option_flags[:line] ? input.lines.count : nil,
    word_count: option_flags[:word] ? input.split.count : nil,
    size: option_flags[:size] ? input.size : nil,
    name: name
  }.compact
end

def build_text_metadata(paths, option_flags)
  text_metadata_collection = paths.map do |path|
    create_text_metadata(option_flags, input: File.read(path), name: path)
  end
  if text_metadata_collection.length > 1
    text_metadata_collection + [calculate_total(text_metadata_collection, option_flags)]
  else
    text_metadata_collection
  end
end

def calculate_total(text_metadata_collection, option_flags)
  line_count_sum = option_flags[:line] ? 0 : nil
  word_count_sum = option_flags[:word] ? 0 :nil
  size_sum = option_flags[:size] ? 0 :nil
  text_metadata_collection.each do |text_metadata|
    line_count_sum += text_metadata[:line_count] if option_flags[:line]
    word_count_sum += text_metadata[:word_count] if option_flags[:word]
    size_sum += text_metadata[:size] if option_flags[:size]
  end
  { line_count: line_count_sum, word_count: word_count_sum, size: size_sum, name: 'total' }.compact
end

def calculate_output_width(text_metadata_collection)
  widths = text_metadata_collection.map do |text_metadata|
    %i[line_count word_count size].map do |key|
      text_metadata[key].to_s.length
    end
  end
  widths.flatten.max  
end

def render(text_metadata, width)
  text_metadata.each do |key, data|
    print adjust_style(data, width, key)
  end
  puts ''
end

def adjust_style(data, width, key)
  str_data = data.to_s
  %i[line_count word_count size].include?(key) ? "#{str_data.rjust(width)} " : str_data
end

main
