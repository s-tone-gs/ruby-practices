# frozen_string_literal: true

module My
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

    attr_reader :name

    private_constant :FILE_TYPES, :PERMISSIONS

    def initialize(name)
      @name = name
      @state = ::File.stat(name)
    end

    def str_mode
      int_mode = @state.mode.to_s(8).rjust(6, '0')
      FILE_TYPES[int_mode[0..1]] + int_mode[3..5].chars.map { |mode| PERMISSIONS[mode] }.join
    end

    def nlink
      @state.nlink
    end

    def owner
      uid = @state.uid
      Etc.getpwuid(uid)
    end

    def group
      gid = @state.gid
      Etc.getgrgid(gid)
    end

    def size
      @state.size.to_s
    end

    def blocks
      @state.blocks
    end

    def mtime
      @state.mtime.strftime('%b %d %H:%M').to_s
    end
  end
end
