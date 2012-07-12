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
    if get(key)
      entry = find_entry(key)
      entry.value = value
    else
      @cache.unshift(Entry.new(key, value))
      if @population == @size
        @cache.pop
      else
        @population += 1
      end
    end
  end

  def get(key)
    entry = find_entry(key)
    entry.value if entry
  end

  protected

  def find_entry(key)
    @cache.find { |entry| entry.key == key }
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
    if get(key)
      get_entry(key).value = value
    else
      @sequence += 1
      pos = @sequence % @size
      doomed_entry = @cache[pos]
      @keys.delete(doomed_entry.key) if doomed_entry
      @cache[pos] = Entry.new(key, value)
      @keys[key] = pos
    end
  end

  def get(key)
    entry = get_entry(key)
    entry.value if entry
  end

  protected

  def get_entry(key)
    pos = @keys[key]
    pos ? @cache[pos] : nil
  end
end