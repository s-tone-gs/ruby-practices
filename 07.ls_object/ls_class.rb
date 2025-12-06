# frozen_string_literal: true

require 'debug'

class Ls
  def initialize(files, column_count, content_widths)
    row_count = files.count.ceildiv(column_count)
    @matrixed_files = build_matrix(row_count, column_count, files)
    @content_widths = content_widths
  end

  # このメソッドが利用者との接点となる。
  # 子クラスはgenerateを適宜オーバーライドしてこのメソッドの結果を操作する。子クラスの実装で荒らされることが無いようにしたかったためそのようにした。
  def self.generate(files)
    new(files).generate
  end

  def generate
    generate_rows(@matrixed_files)
  end

  private_class_method :new

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

  def generate_rows(matrixed_files)
    matrixed_files.map do |files|
      generate_row(files)
    end.join("\n")
  end

  def generate_row(files)
    files.map do |file|
      generate_content(file)
    end.join(' ')
  end

  def generate_content(file)
    raise NotImplementedError
  end
end
