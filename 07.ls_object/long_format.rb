# frozen_string_literal: true

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

  private

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
