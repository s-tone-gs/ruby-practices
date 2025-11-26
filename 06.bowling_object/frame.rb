# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_score, second_score, third_score = nil)
    @first_shot = Shot.new(first_score)
    @second_shot = Shot.new(second_score)
    @third_shot = third_score.nil? ? nil : Shot.new(third_score)
  end

  def total_score(next_frame, after_the_next_frame)
    return [@first_shot.score, @second_shot.score, @third_shot.score].sum unless @third_shot.nil?

    total_score = total_score_first_and_second
    total_score += strike_bounus(next_frame, after_the_next_frame) if strike?
    total_score += spare_bounus(next_frame) if spare?
    total_score
  end

  def total_score_first_and_second
    [@first_shot, @second_shot].map(&:score).sum
  end

  def strike_bounus(next_frame, after_the_next_frame)
    if next_frame.strike?
      # 9フレーム目の場合
      return next_frame.total_score_first_and_second if after_the_next_frame.nil?

      next_frame.first_shot.score + after_the_next_frame.first_shot.score
    else
      next_frame.total_score_first_and_second
    end
  end

  def spare_bounus(next_frame)
    next_frame.first_shot.score
  end

  def spare?
    @first_shot.score + @second_shot.score == 10 && @first_shot.score != 10
  end

  def strike?
    @first_shot.score == 10
  end
end
