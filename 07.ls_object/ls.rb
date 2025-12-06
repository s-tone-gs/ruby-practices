# frozen_string_literal: true

require 'optparse'
require_relative 'get_files'
require_relative 'default_ls'
require_relative 'long_format_ls'

opt = OptionParser.new
all = false
reverse = false
long_format = false
opt.on('-a') { |v| all = v }
opt.on('-r') { |v| reverse = v }
opt.on('-l') { |v| long_format = v }
opt.parse(ARGV)

files = get_files(all, reverse)
puts long_format ? LongFormatLs.generate(files) : DefaultLs.generate(files)
