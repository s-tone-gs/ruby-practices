#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative './bowling_method'

frames = format_score(ARGV[0])
puts sum_score(frames)
