#! /usr/bin/env ruby
require 'date'
require 'optparse'

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
# ネストされた配列の値を呼び出す際にエラーが起こらないように空配列をセットしてある
calendar = [%w[Su Mo Tu We Th Fr Sa], []]
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

# カレンダーのデータを作成
def generate_calendar_data(year, month, calendar)
  week_number = 1
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)
  (first_day.day..last_day.day).each do |day|
    date = Date.new(year, month, day)
    calendar[week_number][date.wday] = day
    if date.wday == 6
      calendar.push([])
      week_number += 1
    end
  end
  return calendar
end

# カレンダーデータをもとにカレンダーを表示
def print_calendar(year, months, month, calendar)
  printf('%8s', months[month])
  printf("%8s\n", year)
  calendar.each do |row|
    row.each do |cell|
      printf('%3s', cell.to_s)
    end
    puts ''
  end
end

calendar = generate_calendar_data(YEAR, MONTH, calendar)
print_calendar(YEAR, MONTHS, MONTH, calendar) 
