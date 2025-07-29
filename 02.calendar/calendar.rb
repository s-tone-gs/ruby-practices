#! /usr/bin/env ruby 
require 'date'
require 'optparse'

# 入力データのチェック
def check_inputs(inputs)
  year = inputs['y']
  month = inputs['m']
  if !year.nil? && !(year.to_i >= 1873)
    raise '-yの引数には1873以上の数値を入力してください'
  end
  if !month.nil? && !month.to_i.between?(1,12)
    raise '-mの引数には1から12の数値を入力してください'
  end
end
inputs = ARGV.getopts("y:", 'm:')
check_inputs(inputs)

year = if inputs['y'].nil? then Date.today.year else inputs['y'].to_i end
month = if inputs['m'].nil? then Date.today.month else inputs['m'].to_i end
# ネストされた配列の値を呼び出す際にエラーが起こらないように空配列をセットしてある
calendar = [['Su','Mo','Tu','We','Th','Fr','Sa'],[]]

# カレンダーのデータを作成
def make_calendar_data(year, month, calendar)
  week_number = 1
  first_day = Date.new(year, month, 1).day
  last_day = Date.new(year,month,-1).day
  (first_day..last_day).to_a.each do |day|
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
def make_calendar(year, month, calendar) 
  months = {1 => "January",2 => "February",3 => "March",4 => "April",5 => "May",6 => "June",7 => "July",8 => "August",9 => "September",10 => "October",11 => "November",12 => "December"}
  printf("%8s", year)
  printf("%8s\n", months[month])
  calendar.each do |x|
    x.each do |y|
      printf("%3s", y.to_s)
    end
    puts ''
  end
end

calendar = make_calendar_data(year, month, calendar)
make_calendar(year, month, calendar) 
