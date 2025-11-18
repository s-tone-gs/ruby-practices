# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(string_score)
    @score = to_int_score(string_score)
  end

  private

  def to_int_score(string_score)
    return 10 if string_score == 'X'

    string_score.to_i
  end
end
