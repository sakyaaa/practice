# frozen_string_literal: true

# HashMap implementation
class HashMap
  attr_reader :load_factor, :capacity, :buckets, :size

  def initialize(load_factor = 0.75, capacity = 16)
    @load_factor = load_factor
    @capacity = capacity
    @buckets = Array.new(capacity) { [] }
    @size = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char do |char|
      hash_code = (prime_number * hash_code) + char.ord
    end
    hash_code % @capacity
  end

  def set(key, value)
    index = hash(key)
    bucket = @buckets[index]

    existing_pair = bucket.find { |pair| pair[0] == key }

    if existing_pair
      existing_pair[1] = value
    else
      bucket << [key, value]
      @size += 1

      grow_buckets if @size.to_f / @capacity > @load_factor
    end
  end

  def get(key)
    index = hash(key)
    bucket = @buckets[index]
    pair = bucket.find { |pair| pair[0] == key }
    pair ? pair[1] : nil
  end

  def has?(key)
    index = hash(key)
    bucket = @buckets[index]
    bucket.any? { |pair| pair[0] == key }
  end

  def remove(key)
    index = hash(key)
    bucket = @buckets[index]
    pair_index = bucket.find_index { |pair| pair[0] == key }

    if pair_index
      removed_pair = bucket.delete_at(pair_index)
      @size -= 1
      removed_pair[1]
    end

    nil
  end

  def length
    @size
  end

  def clear
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def keys
    result = []
    @buckets.each do |bucket|
      bucket.each { |pair| result << pair[0] }
    end
    result
  end

  def values
    result = []
    @buckets.each do |bucket|
      bucket.each { |pair| result << pair[1] }
    end
    result
  end

  def entries
    result = []
    @buckets.each do |bucket|
      bucket.each { |pair| result << pair }
    end
    result
  end

  private

  def grow_buckets
    old_buckets = @buckets
    @capacity *= 2
    @buckets = Array.new(@capacity) { [] }
    @size = 0

    old_buckets.each do |bucket|
      bucket.each do |key, value|
        set(key, value)
      end
    end
  end
end

test = HashMap.new

test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')
test.set('moon', 'silver')
