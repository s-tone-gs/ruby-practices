(1..20).to_a.each do |number|
  if (number % 15).zero?
    puts 'FizzBuzz'
  elsif (number % 5).zero?
    puts 'Buzz'
  elsif (number % 3).zero?
    puts 'Fizz'
  else
    puts number
  end
end
