# frozen_string_literal: true

def to_int_scores(strings_scores)
  converted_array = []
  strings_scores.each do |score|
    if score == 'X'
      converted_array << 10
      converted_array << 0
    else
      converted_array.push(score.to_i)
    end
  end
  converted_array
end

def parse_scores(raw_scores)
  scores = raw_scores.split(',')
  int_scores = to_int_scores(scores)
  # 10フレーム目でストライクかスペアを出すとframesの要素数が10以上になる。こうすることで10フレーム目のストライク、スペアの得点加算も通常と同じ処理で済むのでこの形にしてある
  int_scores.each_slice(2).to_a
end

def strike?(frame)
  frame[0] == 10
end

def spare?(frame)
  frame[0] + frame[1] == 10
end

def calc_strike_bonus(index, frames)
  next_index = index + 1
  next_frame = frames[next_index]
  if strike? next_frame
    after_next_frame = frames[next_index + 1]
    next_frame[0] + after_next_frame[0]
  else
    next_frame[0] + next_frame[1]
  end
end

def calc_spare_bonus(index, frames)
  next_index = index + 1
  next_frame = frames[next_index]
  next_frame[0]
end

def sum_score(frames)
  total_score = 0
  total_frames = 10
  total_frames.times do |index|
    frame = frames[index]
    total_score += frame[0] + frame[1]
    if strike?(frame)
      total_score += calc_strike_bonus(index, frames)
    elsif spare?(frame)
      total_score += calc_spare_bonus(index, frames)
    end
  end
  total_score
end
