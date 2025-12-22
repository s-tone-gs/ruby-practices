# frozen_string_literal: true

require 'optparse'

class CommandLineOptions
  def initialize
    opt = OptionParser.new
    opt.on('-a') { |v| @all = v }
    opt.on('-r') { |v| @reverse = v }
    opt.on('-l') { |v| @long_format = v }
    opt.parse(ARGV)
  end

  def show_all?
    @all.nil? ? false : @all
  end

  def show_long_format?
    @long_format.nil? ? false : @long_format
  end

  def show_reverse?
    @reverse.nil? ? false : @reverse
  end
end
