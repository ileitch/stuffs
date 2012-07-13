# LRU eviction using a doubly linked list.
class LRUList
  def initialize
    @head = nil
    @tail = nil
  end

  def promote(entry)
    return if entry == @head

    next_entry = entry.next
    prev_entry = entry.previous

    prev_entry.next = next_entry if prev_entry
    next_entry.previous = prev_entry if next_entry
    @tail = entry unless @tail
    @tail = next_entry if next_entry && !prev_entry

    if @head
      entry.previous = @head
      @head.next = entry
    end

    entry.next = nil
    @head = entry

    describe
  end

  def chop_tail
    chopped = @tail
    @tail = chopped.next
    @tail.previous = nil
    chopped
  end

  def describe
    keys = []
    event = @tail
    while event
      keys << "%-5s" % event.key
      event = event.next
    end
    puts keys.join(" -> ")
  end
end

class Entry < Struct.new(:key, :value)
  attr_accessor :previous, :next
end

class Cache
  def initialize(size)
    @size = size
    @cache = Array.new(size, nil)
    @keys = {}
    @population = 0
    @sequence = -1
    @lru = LRUList.new
  end

  def put(key, value)
    if get(key)
      get_entry(key).value = value
    elsif @population == @size
      evicted_entry = @lru.chop_tail
      pos = @keys.delete(evicted_entry.key)
      set(key, value, pos)
    else
      @sequence += 1
      @population += 1
      set(key, value, @sequence % @size)
    end
  end

  def get(key)
    if entry = get_entry(key)
      @lru.promote(entry)
      entry.value
    end
  end

  protected

  def set(key, value, pos)
    entry = Entry.new(key, value)
    @cache[pos] = entry
    @keys[key] = pos
    @lru.promote(entry)
  end

  def get_entry(key)
    pos = @keys[key]
    pos ? @cache[pos] : nil
  end
end

c = Cache.new(3)
c.put(:one, 1)
c.put(:two, 2)
c.put(:three, 3)
c.get(:one)
c.put(:four, 4)
c.get(:three)
c.get(:four)
c.get(:one)
c.put(:five, 5)
c.get(:one)