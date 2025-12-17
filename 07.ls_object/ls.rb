# frozen_string_literal: true

require_relative 'input_builder'
require_relative 'file'
require_relative 'directory_content_output'

class Ls
  def self.run
    files_and_option = InputBuilder.build
    DirectoryContentOutput.run(*files_and_option)
  end
end

Ls.run
