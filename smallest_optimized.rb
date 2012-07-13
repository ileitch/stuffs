# encoding: utf-8

# O(n)
def smallest_missing(ints)
  seen = {}
  missing = nil
  high_possible = nil

  ints.each do |n|
    seen[n] = true
    high_possible += 1 if high_possible == n
    if n == 1
      missing = n + 1 if !seen[n + 1]
    elsif missing
      missing = n - 1 if !seen[n - 1] && (n - 1) < missing
      if !seen[n + 1] && (n + 1) < missing
        missing = n + 1
      else
        missing = high_possible
      end
    else
      missing = n - 1
      high_possible = n + 1
    end
  end
  missing
end

{[5, 6, 3, 9, 2, 3, 4, 1, 7] => 8,
 [6, 5, 4, 3, 2, 1] => 7,
 [6, 5, 4, 3, 1] => 2,
 [99, 3, 2, 9, 9, 8, 1, 1, 4] => 5,
 [1, 2, 3, 4, 5] => 6,
 [1, 1, 1, 1] => 2}.each do |values, expected|
  result = smallest_missing(values)
  if result == expected
    puts "✔ #{result} - #{values.inspect}"
  else
    puts "FUUUU: #{values.inspect}, expected #{expected}, got #{result}"
  end
 end