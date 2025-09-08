# frozen_string_literal: true

require_relative 'ls_method'

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

  files = get_files(target_path, all, reverse)
  print_files(files, list)
end

main
