# frozen_string_literal: true

require 'debug'

class Ls
  def initialize(files)
    @row_count = files.count.ceildiv(column_count)
  end

  def self.generate(files)
    new(files).generate
  end

  private

  def column_count
    3
  end

  def generate
    raise NotImplementedError
  end
end
