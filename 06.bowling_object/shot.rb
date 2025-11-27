# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(string_score)
    @score = string_score == 'X' ? 10 : string_score.to_i
  end
end
