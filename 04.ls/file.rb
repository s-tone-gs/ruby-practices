# frozen_string_literal: true

module LS
  class File
    def initialize(name, path, file_state_instance)
      @name = name
      @path = path
      # 今後オプションで機能を拡張する際に使用する予定
      @file_state_instance = file_state_instance
    end

    attr_reader :name, :path

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
