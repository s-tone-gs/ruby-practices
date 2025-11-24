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
    @frames.each_with_index do |frame, index|
      # 9フレーム目であれば
      if index.equal?(8)
        frame.referable_frames = [@frames[index + 1]]
      else
        # 10フレーム目以外
        frame.referable_frames = [@frames[index + 1], @frames[index + 2]] unless index.equal?(9)
      end
    end
  end

  def total_score
    @frames.sum(&:total_score)
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
