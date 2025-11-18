# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot

  def initialize(first_score, second_score = '0')
    @first_shot = Shot.new(first_score)
    @second_shot = Shot.new(second_score)
  end

  def total_score
    @first_shot.score + @second_shot.score
  end

  def spare?
    total_score == 10 && @first_shot.score != 10
  end

  def strike?
    total_score == 10 && @first_shot.score == 10
  end
end
