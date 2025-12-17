# frozen_string_literal: true

class DirectoryContentOutput
  def self.run(files, long_format)
    directory_content_output = new(files, long_format)
    puts directory_content_output.generate
  end

  def initialize(files, long_format)
    @files = files
    @long_format = long_format
  end

  def generate
    @long_format ? LongFormat.generate(@files) : MultiColumnFormat.generate(@files)
  end

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

    def name_width
      @files.map { |file| file.name.length }.max
    end

    def row_count
      @files.count.ceildiv(COLUMN_COUNT)
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

    def generate_row(files)
      files.map do |file|
        generate_content(file)
      end.join(' ')
    end

    def generate_content(file)
      file.name.ljust(name_width)
    end
  end

  class LongFormat
    def self.generate(files)
      long_format = new(files)
      column = files.map do |file|
        long_format.generate_content(file)
      end.join("\n")

      [
        "total #{long_format.total_block_size}",
        column
      ].join("\n")
    end

    def initialize(files)
      @files = files
    end

    def total_block_size
      # rubyは１ブロックを512バイト、Linuxは１ブロックを1024で計算しているため、２で割っている
      @files.map { |file| file.blocks.div(2) }.sum
    end

    def generate_content(file)
      content_widths = calc_widths
      [
        file.str_mode,
        file.nlink.to_s.rjust(content_widths[:nlink]),
        file.owner.name.rjust(content_widths[:owner]),
        file.group.name.rjust(content_widths[:group]),
        file.size.rjust(content_widths[:size]),
        file.mtime.rjust(content_widths[:mtime]),
        file.name
      ].join(' ')
    end

    def calc_widths
      widths = Hash.new { |hash, key| hash[key] = [] }
      @files.each do |f|
        widths[:owner].push(f.owner.name.length)
        widths[:group].push(f.group.name.length)
        widths[:nlink].push(f.nlink.to_s.length)
        widths[:size].push(f.size.length)
        widths[:mtime].push(f.mtime.length)
        widths[:name].push(f.name.length)
      end
      widths.transform_values(&:max)
    end
  end

  private_constant :MultiColumnFormat, :LongFormat
end
