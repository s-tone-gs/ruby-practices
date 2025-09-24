# frozen_string_literal: true

require 'optparse'

def main
  paths, target_options = options_and_paths
  text_metadata_collection =
    if paths.empty?
      [create_text_metadata(input: $stdin.read)]
    else
      build_text_metadata(paths)
    end
  width = calculate_output_width(text_metadata_collection, target_options)
  text_metadata_collection.each do |text_metadata|
    render(target_options, text_metadata, width)
  end
end

def options_and_paths
  line = false
  word = false
  size = false
  opt = OptionParser.new
  opt.on('-l') { |v| line = v }
  opt.on('-w') { |v| word = v }
  opt.on('-c') { |v| size = v }
  paths = opt.parse(ARGV)
  target_options = if !line && !word && !size
    [:line_count, :word_count, :size]
  else
    {line_count: line, word_count: word, size: size}.map do |option, flag|
      next unless flag
      option
    end
  end
  [paths, target_options]
end

def create_text_metadata(input: , name: nil)
  {
    line_count: input.lines.count,
    word_count: input.split.count,
    size: input.size,
    name: name
  }
end

def build_text_metadata(paths)
  text_metadata_collection = paths.map do |path|
    create_text_metadata(input: File.read(path), name: path)
  end
  if text_metadata_collection.length > 1
    text_metadata_collection + [calculate_total(text_metadata_collection)]
  else
    text_metadata_collection
  end
end

def calculate_total(text_metadata_collection)
  line_count_sum = 0
  word_count_sum = 0
  size_sum = 0
  text_metadata_collection.each do |text_metadata|
    line_count_sum += text_metadata[:line_count]
    word_count_sum += text_metadata[:word_count]
    size_sum += text_metadata[:size]
  end
  { line_count: line_count_sum, word_count: word_count_sum, size: size_sum, name: 'total' }
end

def calculate_output_width(text_metadata_collection, target_options)
  widths = text_metadata_collection.map do |text_metadata|
    target_options.map do |key|
      text_metadata[key].to_s.length
    end
  end
  widths.flatten.max  
end

def render(target_options, text_metadata, width)
  target_options.each do |key|
    print adjust_style(text_metadata[key], width)
  end
  print text_metadata[:name]
  puts ''
end

def adjust_style(metadata, width)
  "#{metadata.to_s.rjust(width)} "
end

main
