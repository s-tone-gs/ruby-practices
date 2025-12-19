# frozen_string_literal: true

require_relative 'input_builder'
require_relative 'file'
require_relative 'directory_content_output'

class Ls
  def self.run
    getting_all, getting_reverse_order, show_in_long_format = CommandLineArgumentsParser.parse
    files = FileMetadata.get_files(getting_all, getting_reverse_order)
    DirectoryContentOutput.run(files, show_in_long_format)
  end
end

Ls.run
