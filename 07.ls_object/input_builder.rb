# frozen_string_literal: true

require 'optparse'
require_relative 'file'

class CommandLineArgumentsParser
  def self.parse
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
