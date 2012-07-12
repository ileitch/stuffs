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