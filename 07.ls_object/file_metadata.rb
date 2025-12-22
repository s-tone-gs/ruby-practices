# frozen_string_literal: true

require 'etc'

class FileMetadata
  FILE_TYPES = {
    '04' => 'd',
    '10' => '-',
    '12' => 'l'
  }.freeze
  PERMISSIONS = {
    '7' => 'rwx',
    '6' => 'rw-',
    '5' => 'r-x',
    '4' => 'r--',
    '3' => '-wx',
    '2' => '-w-',
    '1' => '--x',
    '0' => '---'
  }.freeze

  private_constant :FILE_TYPES, :PERMISSIONS
  attr_reader :name

  def self.get_files(all, reverse)
    flags = all ? File::FNM_DOTMATCH : 0
    files = Dir.glob('*', flags).map { |file_name| new(file_name) }
    asc_order_files = files.sort_by(&:name)
    reverse ? asc_order_files.reverse : asc_order_files
  end

  def initialize(name)
    @name = name
    @stat = ::File.stat(name)
  end

  def str_mode
    int_mode = @stat.mode.to_s(8).rjust(6, '0')
    FILE_TYPES[int_mode[0..1]] + int_mode[3..5].chars.map { |mode| PERMISSIONS[mode] }.join
  end

  def nlink
    @stat.nlink
  end

  def owner
    uid = @stat.uid
    Etc.getpwuid(uid)
  end

  def group
    gid = @stat.gid
    Etc.getgrgid(gid)
  end

  def size
    @stat.size.to_s
  end

  def blocks
    @stat.blocks
  end

  def mtime
    @stat.mtime.strftime('%b %d %H:%M').to_s
  end
end
