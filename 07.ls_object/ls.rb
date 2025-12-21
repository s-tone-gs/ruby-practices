# frozen_string_literal: true

require_relative 'input_builder'
require_relative 'file'
require_relative 'file_list_printer'

class Ls
  def self.run
    getting_all, getting_reverse_order, show_in_long_format = CommandLineArgumentsParser.parse
    files = FileMetadata.get_files(getting_all, getting_reverse_order)
    FileListPrinter.run(files, show_in_long_format)
  end
end

Ls.run
