# frozen_string_literal: true

require_relative 'frame'

class Game
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
      # 10フレーム目の場合nil
      next_frame = !(index.equal?(9)) ? @frames[index + 1] : nil
      # 9, 10フレーム目の場合nil
      after_the_next_frame = !(index.equal?(8) || index.equal?(9)) ? @frames[index + 2] :nil
      total_score += frame.total_score(next_frame, after_the_next_frame)
    end
    total_score
  end

  private

  def parse_scores(row_scores)
    scores = []
    row_scores.split(',').each do |score|
      scores.length < 18 && score == 'X' ? scores.push('X', '0') : scores << score
    end
    tenth_frame_scores = scores[18...scores.count]
    framed_scores = scores[0..17].each_slice(2).to_a
    framed_scores << tenth_frame_scores
  end
end
