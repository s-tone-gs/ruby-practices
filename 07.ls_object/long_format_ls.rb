# frozen_string_literal: true

require_relative 'ls_class'

class LongFormatLs < Ls
  COLUMN_COUNT = 1
  def initialize(files)
    content_widths = calc_widths(files)
    super(files, COLUMN_COUNT, content_widths)
    # rubyは１ブロックを512バイト、Linuxは１ブロックを1024で計算しているため、２で割っている
    @total_block_size = files.map { |file| file.blocks.div(2) }.sum
  end

  def generate
    [
      "total #{@total_block_size}",
      generate_rows(@matrixed_files)
    ].join("\n")
  end

  private

  def generate_content(file)
    [
      file.str_mode,
      file.nlink.to_s.rjust(@content_widths[:nlink]),
      file.owner.name.rjust(@content_widths[:owner]),
      file.group.name.rjust(@content_widths[:group]),
      file.size.rjust(@content_widths[:size]),
      file.mtime.rjust(@content_widths[:mtime]),
      file.name
    ].join(' ')
  end

  def calc_widths(files)
    widths = Hash.new { |hash, key| hash[key] = [] }
    files.each do |f|
      widths[:owner].push(f.owner.name.length)
      widths[:group].push(f.group.name.length)
      widths[:nlink].push(f.nlink.to_s.length)
      widths[:size].push(f.size.length)
      widths[:mtime].push(f.mtime.length)
      widths[:name].push(f.name.length)
    end
    widths.transform_values { |widths| widths.max }
  end
end
