# frozen_string_literal: true

class MultiColumnFormat
  COLUMN_COUNT = 3

  def self.generate(files)
    multi_column_format = new(files)
    matrixed_files = multi_column_format.build_matrix
    multi_column_format.generate_rows(matrixed_files)
  end

  def initialize(files)
    @files = files
  end
  
  def build_matrix
    (0...row_count).map do |i|
      index_to_row_value = i
      (0...COLUMN_COUNT).map do
        index_to_target = index_to_row_value
        index_to_row_value += row_count
        @files[index_to_target]
      end.compact
    end
  end

  def generate_rows(matrixed_files)
    matrixed_files.map do |files|
      generate_row(files)
    end.join("\n")
  end

  private

  def name_width
    @files.map { |file| file.name.length }.max
  end

  def row_count
    @files.count.ceildiv(COLUMN_COUNT)
  end


  def generate_row(files)
    files.map do |file|
      generate_content(file)
    end.join(' ')
  end

  def generate_content(file)
    file.name.ljust(name_width)
  end
end
