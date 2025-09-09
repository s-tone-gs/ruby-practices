# frozen_string_literal: true

require_relative 'ls_method'

def main
  option_and_path(ARGV) => { all:, reverse:, list:, paths: }
  target_path = check_path(paths)
  files = get_files(target_path, all, reverse)
  print_files(files, list)
end

main
