# frozen_string_literal: true

require 'optparse'

def main
  paths, option_flags = option_and_paths
  text_metadata_collection =
    if paths.empty?
      [set_text_metadata(option_flags, input: $stdin.read)]
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
  byte = false
  opt = OptionParser.new
  opt.on('-l') { |v| line = v }
  opt.on('-w') { |v| word = v }
  opt.on('-c') { |v| byte = v }
  paths = opt.parse(ARGV)
  if !line && !word && !byte
    [ paths, { line: true, word: true, byte: true} ]
  else
    [ paths, { line:, word:, byte:, paths: } ]
  end
end

def set_text_metadata(option_flags, message: nil, input: '', name: nil)
  {
    message: message,
    line_count: option_flags[:line] ? input.lines.count : nil,
    word_count: option_flags[:word] ? input.split.count : nil,
    size: option_flags[:byte] ? input.size : nil,
    name: name
  }.compact
end

def build_text_metadata(paths, option_flags)
  text_metadata_collection = paths.map do |path|
    if File.directory?(path)
      set_text_metadata(option_flags, message: "wc: #{path}: Is a directory\n", name: path)
    elsif !File.exist?(path)
      %r{/$}.match?(path) ? { error: "wc: #{path}: Not a directory" } : { error: "wc: #{path}: No such file or directory" }
    else
      set_text_metadata(option_flags, input: File.read(path), name: path)
    end
  end
  if text_metadata_collection.length > 1
    text_metadata_collection + [calculate_total(text_metadata_collection)]
  else
    text_metadata_collection
  end
end

def calculate_total(text_metadata_collection)
  totals = text_metadata_collection.each_with_object({}) do |text_metadata, temporary|
    text_metadata.each do |key, data|
      # text_metadataにはtotalを求めたい値以外も存在するためフィルタをかけている
      temporary[key] = (temporary[key] || 0) + data if %i[line_count word_count size].include?(key)
    end
  end
  totals.merge(name: 'total')
end

def calculate_output_width(text_metadata_collection)
  text_metadata_collection.each_with_object([]) do |text_metadata, widths|
    %i[line_count word_count size].each do |key|
      widths << text_metadata[key].to_s.length
    end
  end.compact.max
end

def render(text_metadata, width)
  text_metadata.each do |key, data|
    print adjust_style(data, width, key)
  end
  puts ''
end

def adjust_style(data, width, key)
  str_data = data.to_s
  return "#{str_data.rjust(width)} " if %i[line_count word_count size].include?(key)

  str_data.ljust(width)
end

main
