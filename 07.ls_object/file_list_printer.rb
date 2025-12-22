# frozen_string_literal: true

require_relative 'multi_column_format'
require_relative 'long_format'

class FileListPrinter
  def self.run(files, long_format)
    file_list_printer = new(files, long_format)
    puts file_list_printer.generate
  end

  def initialize(files, long_format)
    @files = files
    @long_format = long_format
  end

  def generate
    @long_format ? LongFormat.generate(@files) : MultiColumnFormat.generate(@files)
  end
end
