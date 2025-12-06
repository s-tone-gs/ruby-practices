# frozen_string_literal: true

require_relative 'ls_class'
require_relative 'common_ls_method'

class ListLs < Ls
  include CommonLsMethod
  def initialize(files)
    super(files)
    @matrixed_files = build_matrix(@row_count, column_count, files)
    # rubyは１ブロックを512バイト、Linuxは１ブロックを1024で計算しているため、２で割っている
    @total_block_size = files.map { |file| file.blocks.div(2) }.sum
    @widths = calc_widths(files)
  end

  def generate
    [
      "total #{@total_block_size}",
      generate_rows(@matrixed_files, @widths)
    ].join("\n")
  end

  private

  def generate_row(files, widths)
    # -lオプションが有効な時は必ず一列になるため、このように取得する
    file = files[0]
    [
      file.str_mode,
      file.nlink.to_s.rjust(widths[:nlink]),
      file.owner.name.rjust(widths[:owner]),
      file.group.name.rjust(widths[:group]),
      file.size.rjust(widths[:size]),
      file.mtime.rjust(widths[:mtime]),
      file.name
    ].join(' ')
  end

  def column_count
    1
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
