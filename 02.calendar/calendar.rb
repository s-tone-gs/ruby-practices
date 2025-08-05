#! /usr/bin/env ruby
require 'date'
require 'optparse'
require 'debug'

# 入力データのチェック
def check_inputs(inputs)
  year = inputs['y']
  month = inputs['m']
  if !year.nil? && year.to_i < 1873
    puts '-yの引数には1873以上の数値を入力してください'
    exit(1)
  end
  if !month.nil? && !month.to_i.between?(1,12)
    puts '-mの引数には1から12の数値を入力してください'
    exit(1)
  end
end

inputs = ARGV.getopts('y:', 'm:')
check_inputs(inputs)
YEAR = inputs['y'].nil? ? Date.today.year : inputs['y'].to_i
MONTH = inputs['m'].nil? ? Date.today.month : inputs['m'].to_i
WEEKS = %w[Su Mo Tu We Th Fr Sa] 
MONTHS = { 1 => 'January',
           2 => 'February',
           3 => 'March',
           4 => 'April',
           5 => 'May',
           6 => 'June',
           7 => 'July',
           8 => 'August',
           9 => 'September',
           10 => 'October',
           11 => 'November',
           12 => 'December' }
# 出力する際に週と日付が同じ配列にあったほうが出力が楽であるため週と日を一緒にしてある
calendar = {:year => YEAR, :month => MONTHS[MONTH], :weeks_and_days => []}

def get_days(year, month)
  week_number = 1
  # 呼び出す際にエラーにならないように空配列を入れてある
  days = [[]]
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)
  (first_day.day..last_day.day).each do |day|
    date = Date.new(year, month, day)
    # 第1週はdaysのインデックス0に格納、のように週番号とインデックスがずれるため-1という処理を行っている
    days[week_number - 1][date.wday] = day
    if date.wday == 6
      days.push([])
      week_number += 1
    end
  end
  return days
end

# カレンダーデータをもとにカレンダーを表示
def print_calendar(calendar)
  printf('%8s', calendar[:month])
  printf("%8s\n", calendar[:year])
  calendar[:weeks_and_days].each do |row|
    row.each do |cell|
      printf('%3s', cell.to_s)
    end
    puts ''
  end
end

calendar[:weeks_and_days] = get_days(YEAR, MONTH)
calendar[:weeks_and_days].unshift(WEEKS)
print_calendar(calendar) 
