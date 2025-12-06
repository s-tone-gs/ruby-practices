# frozen_string_literal: true

require_relative 'ls_class'
require_relative 'common_ls_method'

class DefaultLs < Ls
  include CommonLsMethod
  def initialize(files)
    super(files)
    @matrixed_files = build_matrix(@row_count, column_count, files)
    @name_width = files.map { |file| file.name.length }.max
  end

  def column_count
    3
  end

  def generate
    generate_rows(@matrixed_files, @name_width)
  end
end
