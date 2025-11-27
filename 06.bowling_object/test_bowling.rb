# frozen_string_literal: true

require_relative 'game'

def main
  test_bowling_return_139
  test_bowling_return_164
  test_bowling_return_107
  test_bowling_return_134
  test_bowling_return_144
  test_bowling_return_300
  test_bowling_return_292
  test_bowling_return_50
end

def test_bowling_return_139
  template_test_bowling('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5', 139)
end

def test_bowling_return_164
  template_test_bowling('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X', 164)
end

def test_bowling_return_107
  template_test_bowling('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4', 107)
end

def test_bowling_return_134
  template_test_bowling('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0', 134)
end

def test_bowling_return_144
  template_test_bowling('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8', 144)
end

def test_bowling_return_300
  template_test_bowling('X,X,X,X,X,X,X,X,X,X,X,X', 300)
end

def test_bowling_return_292
  template_test_bowling('X,X,X,X,X,X,X,X,X,X,X,2', 292)
end

def test_bowling_return_50
  template_test_bowling('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0', 50)
end

def template_test_bowling(input, expected)
  game = Game.new(input)
  puts "入力したスコア：#{input}"
  puts "expected: #{expected}"

  total_score = game.total_score
  puts "actual: #{total_score}"

  if total_score == expected
    puts '正常'
  else
    puts '異常'
  end
  puts ''
end

main
