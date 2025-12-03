# frozen_string_literal: true

module CommonLsMethod
  private

  def build_matrix(row_count, column_count, files)
    (0...row_count).map do |i|
      index_to_row_value = i
      (0...column_count).map do
        index_to_target = index_to_row_value
        index_to_row_value += row_count
        files[index_to_target]
      end.compact
    end
  end

  def generate_rows(matrixed_files, width)
    matrixed_files.map do |files|
      generate_row(files, width)
    end.join("\n")
  end

  def generate_row(files, width)
    files.map do |file|
      files.last.equal?(file) ? file.name : file.name.ljust(width)
    end.join
  end
end
