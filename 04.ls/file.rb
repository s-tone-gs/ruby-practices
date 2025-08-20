# frozen_string_literal: true

module LS
  class File
    def initialize(name, file_state_instance)
      @name = name
      # 今後オプションで機能を拡張する際に使用する予定
      @file_state_instance = file_state_instance
    end

    attr_reader :name

    def directory?
      @file_state_instance.directory?
    end
  end
end
