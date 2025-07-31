def strings_to_numbers(scores)
  converted_array = []
  scores.each do |score| 
    if score == 'X'
      converted_array << 10
      converted_array << 0
    else
      converted_array.push(score.to_i)
    end
  end
  converted_array
end

def format_score(raw_scores)
  scores = raw_scores.split(',')
  integer_scores = strings_to_numbers(scores) 
  # 10フレーム目でストライクかスペアを出すとframesの要素数が10以上になる。こうすることで10フレーム目のストライク、スペアの得点加算も通常と同じ処理で済むのでこの形にしてある
  formatted_scores = integer_scores.each_slice(2).to_a
end

def strike?(frame)
  frame[0] == 10 ? true : false
end

def spare?(frame)
  frame[0] + frame[1] == 10 ? true : false
end

def add_strike_bonus (index, frames)
  strike_bonus = 0
  next_index = index + 1
  next_frame = frames[next_index]
  if strike? next_frame
    after_next_frame = frames[next_index + 1]
    strike_bonus += next_frame[0] +  after_next_frame[0]
  else 
    strike_bonus += next_frame[0] + next_frame[1]
  end
end
    
def add_spare_bonus (index, frames)
  spare_bonus = 0
  next_index = index + 1
  next_frame = frames[next_index]
  spare_bonus += next_frame[0] 
end

def sum_score(frames)
  total_score = 0
  total_frames = 10
  total_frames.times do |index|
    frame = frames[index]
    total_score += frame[0] + frame[1]
    if strike?(frame)
      total_score += add_strike_bonus(index, frames)
    elsif spare?(frame)
      total_score += add_spare_bonus(index, frames)
    end
  end
  total_score
end

