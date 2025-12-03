# frozen_string_literal: true

require_relative 'file'

def get_files(all, reverse)
  flags = all ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags).map { |file_name| My::File.new(file_name) }
  asc_order_files = files.sort_by(&:name)
  reverse ? asc_order_files.reverse : asc_order_files
end
