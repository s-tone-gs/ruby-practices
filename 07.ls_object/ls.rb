# frozen_string_literal: true

require_relative 'command_line_options'
require_relative 'file'
require_relative 'file_list_printer'

class Ls
  def self.run
    options = CommandLineOptions.new
    files = FileMetadata.get_files(options.show_all?, options.show_reverse?)
    FileListPrinter.run(files, options.show_long_format?)
  end
end

Ls.run
