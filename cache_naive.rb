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
