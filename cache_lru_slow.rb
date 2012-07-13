# LRU eviction.
class Cache
  class Entry < Struct.new(:key, :value); end

  def initialize(size)
    @size = size
    @cache = Array.new(size, nil)
    @keys = {}
    @population = 0
    @sequence = -1
    @lru = []
  end

  def put(key, value)
    if get(key)
      get_entry(key).value = value
    elsif @population == @size
      evicted_key = @lru.shift
      pos = @keys.delete(evicted_key)
      set(key, value, pos)
    else
      @sequence += 1
      @population += 1
      set(key, value, @sequence % @size)
    end
  end

  def get(key)
    if entry = get_entry(key)
      refresh(entry.key)
      entry.value
    end
  end

  protected

  def set(key, value, pos)
    @cache[pos] = Entry.new(key, value)
    @keys[key] = pos
    refresh(key)
  end

  def get_entry(key)
    pos = @keys[key]
    pos ? @cache[pos] : nil
  end

  def refresh(key)
    @lru.delete(key)
    @lru.push(key)
  end
end