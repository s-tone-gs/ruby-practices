# frozen_string_literal: true

require_relative 'ls_class'

class MultiColumnLs < Ls
  COLUMN_COUNT = 3
  def initialize(files)
    name_width = files.map { |file| file.name.length }.max
    content_widths = { name: name_width }
    super(files, COLUMN_COUNT, content_widths)
  end

  def generate_content(file)
    file.name.ljust(@content_widths[:name])
  end
end
