# frozen_string_literal: true

require_relative 'multi_column_format'
require_relative 'long_format'

class DirectoryContentOutput
  def self.run(files, long_format)
    directory_content_output = new(files, long_format)
    puts directory_content_output.generate
  end

  def initialize(files, long_format)
    @files = files
    @long_format = long_format
  end

  def generate
    @long_format ? LongFormat.generate(@files) : MultiColumnFormat.generate(@files)
  end
end
