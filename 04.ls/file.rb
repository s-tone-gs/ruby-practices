# frozen_string_literal: true

require 'etc'

module LS
  class File
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

    def initialize(name, path)
      @name = name
      @path = path
      # 今後オプションで機能を拡張する際に使用する予定
      @file_state_instance = ::File.lstat(path)
    end

    attr_reader :name, :path

    def mode
      @file_state_instance.mode
    end

    def str_mode
      int_mode = mode.to_s(8).rjust(6, '0')
      FILE_TYPES[int_mode[0..1]] + int_mode[3..5].chars.map { |mode| PERMISSIONS[mode] }.join
    end

    def nlink
      @file_state_instance.nlink.to_s
    end

    def owner
      uid = @file_state_instance.uid
      Etc.getpwuid(uid)
    end

    def group
      gid = @file_state_instance.gid
      Etc.getgrgid(gid)
    end

    def size
      @file_state_instance.size.to_s
    end

    def blocks
      @file_state_instance.blocks
    end

    def mtime
      @file_state_instance.mtime.strftime('%b %d %H:%M').to_s
    end

    def directory?
      @file_state_instance.directory?
    end

    def symlink?
      @file_state_instance.symlink?
    end

    def executable?
      @file_state_instance.executable?
    end
  end
end
