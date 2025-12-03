# frozen_string_literal: true

require 'optparse'
require_relative 'get_files'
require_relative 'default_ls'
require_relative 'list_ls'

opt = OptionParser.new
all = false
reverse = false
list = false
opt.on('-a') { |v| all = v }
opt.on('-r') { |v| reverse = v }
opt.on('-l') { |v| list = v }
opt.parse(ARGV)

files = get_files(all, reverse)
puts list ? ListLs.generate(files) : DefaultLs.generate(files)
