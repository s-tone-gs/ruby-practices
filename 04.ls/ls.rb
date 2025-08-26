# frozen_string_literal: true

require_relative 'ls_method'

def main
  path = if ARGV[0].nil?
           './'
         else
           exit_if_not_exist(ARGV[0]) unless FileTest.exist?(ARGV[0])
           exit_file_is_true(ARGV[0]) if FileTest.file?(ARGV[0])
           # ディレクトリの記述が/で終わっているかいないかで分岐
           %r{\S*/$}.match?(ARGV[0]) ? ARGV[0] : "#{ARGV[0]}/"
         end

  files = get_files(path)
  exit_if_file_not_found if files.empty?
  build_files = build_files(files)
  print_files(build_files)
end

main
