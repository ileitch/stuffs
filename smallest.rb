# == smallest-missing ==

# My original approach.
def smallest_missing(ints)
  ints.sort!
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

smallest_missing([1, 3, 5])
smallest_missing([2, 3, 100, 2])
smallest_missing([5, 4, 1, 2])
smallest_missing([3, 2, 1])

#== caching ==

# Naive approach. Inefficient.
class Cache
  class Entry < Struct.new(:key, :value); end

  def initialize(size)
    @size = size
    @cache = []
    @population = 0
  end

  def put(key, value)
    unless get(key)
      @cache.unshift(Entry.new(key, value))
      if @population == @size
        @cache.pop
      else
        @population += 1
      end
    end
  end

  def get(key)
    entry = @cache.find { |entry| entry.key == key }
    entry.value if entry
  end
end

# My original idea, avoids linear lookup.
class Cache
  class Entry < Struct.new(:key, :value); end

  def initialize(size)
    @size = size
    @cache = Array.new(@size, nil)
    @keys = {}
    @sequence = -1
  end

  def put(key, value)
    unless get(key)
      @sequence += 1
      pos = @sequence % @size
      doomed_entry = @cache[pos]
      @keys.delete(doomed_entry.key) if doomed_entry
      @cache[pos] = Entry.new(key, value)
      @keys[key] = pos
    end
  end

  def get(key)
    pos = @keys[key]
    pos ? @cache[pos].value : nil
  end
end