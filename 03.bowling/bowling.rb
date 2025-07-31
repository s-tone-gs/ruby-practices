#! /usr/bin/env ruby
require_relative './bowling_method'

frames = format_score(ARGV[0])
puts sum_score(frames)

