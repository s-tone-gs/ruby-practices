# frozen_string_literal: true

require_relative 'ls_method'
require 'debug'

def main
  option_and_path(ARGV) => { all:, reverse:, list:, paths: }
  target_path = if paths[0].nil?
                  './'
                else
                  exit_if_not_exist(paths[0]) unless FileTest.exist?(paths[0])
                  exit_file_is_true(paths[0]) if FileTest.file?(paths[0])
                  # ディレクトリの記述が/で終わっているかいないかで分岐
                  %r{\S*/$}.match?(paths[0]) ? paths[0] : "#{paths[0]}/"
                end

  files = get_files(target_path, all)
  exit_if_file_not_found if files.empty?
  files.reverse! if reverse
  # build_fileはfilesを破壊的に変更しているので、filesを引数にとるメソッドをbuild_files以下に配置するとエラーになります
  widths = get_widths_and_puts_total(list, files)
  build_files = build_files(list, files)
  print_files(build_files, list, widths)
end

main
