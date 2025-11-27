# frozen_string_literal: true

require_relative 'frame'

class Game
  ONE_TO_NICE_FRAMES_SHOTS_COUNT = 2 * 9
  def initialize(row_scores)
    framed_scores = parse_scores(row_scores)
    # Frameクラス内のfirst_shot, second_shotとは命名の法則が異なっており統一感は無いが、
    # ここでfirst_frame, second_frame・・・と宣言したら全体の記述が長くなり、
    # むしろ可読性が落ちると判断したので配列で宣言
    @frames = framed_scores.map do |score|
      Frame.new(*score)
    end
  end

  def total_score
    total_score = 0
    @frames.each_with_index do |frame, index|
      next_frame, after_the_next_frame = @frames[index + 1, 2]
      total_score += frame.total_score(next_frame, after_the_next_frame)
    end
    total_score
  end

  private

  def parse_scores(row_scores)
    scores = []
    row_scores.split(',').each do |score|
      scores.length < ONE_TO_NICE_FRAMES_SHOTS_COUNT && score == 'X' ? scores.push('X', '0') : scores << score
    end
    tenth_frame_scores = scores[ONE_TO_NICE_FRAMES_SHOTS_COUNT...scores.count]
    framed_scores = scores.take(ONE_TO_NICE_FRAMES_SHOTS_COUNT).each_slice(2).to_a
    framed_scores << tenth_frame_scores
  end
end
