# frozen_string_literal: true

require 'optparse'
require_relative 'file'

class InputBuilder
  def self.build
    input_builder = new
    all, reverse, long_format = input_builder.parse_options
    files = FileMetadata.get_files(all, reverse)
    [files, long_format]
  end

  def parse_options
    opt = OptionParser.new
    all = false
    reverse = false
    long_format = false
    opt.on('-a') { |v| all = v }
    opt.on('-r') { |v| reverse = v }
    opt.on('-l') { |v| long_format = v }
    opt.parse(ARGV)
    [all, reverse, long_format]
  end
end
