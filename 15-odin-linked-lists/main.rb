# frozen_string_literal: true

# Linked list implementation
class LinkedList
  attr_reader :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    new_node = Node.new(value)
    if @head.nil?
      @head = new_node
    else
      @tail.next_node = new_node
    end
    @tail = new_node
  end

  def prepend(value)
    new_node = Node.new(value)
    if @head.nil?
      @head = new_node
      @tail = new_node
    else
      new_node.next_node = @head
      @head = new_node
    end
  end

  def size
    count = 0
    current = @head
    until current.nil?
      count += 1
      current = current.next_node
    end
    count
  end

  def at(index)
    return nil if index.negative? || index >= size

    current = @head
    index.times { current = current.next_node }
    current
  end

  def pop
    return nil if @head.nil?

    if @head == @tail
      popped = @head
      @head = nil
      @tail = nil
      return popped
    end

    current = @head
    current = current.next_node until current.next_node == @tail
    popped = @tail
    current.next_node = nil
    @tail = current
    popped
  end

  def contains?(value)
    current = @head
    until current.nil?
      return true if current.value == value

      current = current.next_node
    end
    false
  end

  def find(value)
    current = @head
    index = 0
    until current.nil?
      return index if current.value == value

      current = current.next_node
      index += 1
    end
    nil
  end

  def to_s
    current = @head
    result = ''
    until current.nil?
      result += "( #{current.value} )"
      result += ' -> ' if current.next_node
      current = current.next_node
    end
    result
  end

  def insert_at(value, index)
    return prepend(value) if index.zero?
    return append(value) if index >= size

    new_node = Node.new(value)
    current = @head
    (index - 1).times { current = current.next_node }
    new_node.next_node = current.next_node
    current.next_node = new_node
  end

  def remove_at(index)
    return nil if index.negative? || index >= size
    return pop if index == size - 1

    if index.zero?
      removed = @head
      @head = @head.next_node
      return removed
    end

    current = @head
    (index - 1).times { current = current.next_node }
    removed = current.next_node
    current.next_node = current.next_node.next_node
    removed
  end
end

# Node implementation
class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end

# Example
list = LinkedList.new
list.append(10)
list.append(20)
list.prepend(5)
list.append(30)
puts "Initial list: #{list}"

list.insert_at(15, 2)
puts "After inserting 15 at index 2: #{list}"

removed = list.remove_at(1)
puts "After removing value #{removed.value} at index 1: #{list}"

puts "Size of list: #{list.size}"
puts "Head value: #{list.head.value}"
puts "Tail value: #{list.tail.value}"
puts "Value at index 2: #{list.at(2).value}"
