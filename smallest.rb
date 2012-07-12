# == smallest-missing ==

# My original approach.
def smallest_missing(ints)
  ints.sort!.uniq!
  return ints.first - 1 if ints.first > 1
  ints.size.times do |i|
    return ints[i] + 1 if ints[i] + 1 != ints[i + 1]
  end
end

# A more pure approach.
# Possibly less efficient if the range is large.
def smallest_missing(ints)
  ((1..ints.max + 1).to_a - ints).min
end