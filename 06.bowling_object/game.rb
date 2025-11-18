# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(row_scores)
    framed_scores = parse_scores(row_scores)
    # Frameクラス内のfirst_shot, second_shotとは命名の法則が異なっており統一感は無いが、
    # ここでfirst_frame, second_frame・・・と宣言したら全体の記述が長くなり、
    # むしろ可読性が落ちると判断したので配列で宣言
    @frames = framed_scores.map do |score|
      # 基本は10フレームだが、10フレーム目でスペアかストライクを出すと11フレーム生成される。
      # 得点計算の処理を単純にできるのでこうしている
      Frame.new(*score)
    end
  end

  def total_score
    total_score = 0
    frame_count = 10
    frame_count.times do |index|
      frame = @frames[index]
      total_score += frame.total_score
      total_score += calc_strike_bounus(index) if frame.strike?
      total_score += calc_spare_bounus(index) if frame.spare?
    end
    total_score
  end

  private

  def parse_scores(row_scores)
    scores = row_scores.split(',').flat_map do |score|
      score == 'X' ? %w[X 0] : score
    end
    scores.each_slice(2).to_a
  end

  def calc_strike_bounus(index)
    next_index = index + 1
    after_the_next = next_index + 1
    if @frames[next_index].strike?
      @frames[next_index].first_shot.score + @frames[after_the_next].first_shot.score
    else
      @frames[next_index].total_score
    end
  end

  def calc_spare_bounus(index)
    next_index = index + 1
    @frames[next_index].first_shot.score
  end
end
