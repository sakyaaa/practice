# frozen_string_literal: true

# Node implementation
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    data <=> other.data
  end
end

# Binary search tree implementation
class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?

    array = array.uniq.sort
    return Node.new(array[0]) if array.length == 1

    mid = array.length / 2
    root = Node.new(array[mid])
    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[mid + 1..])
    root
  end

  def insert(value, node = @root)
    return Node.new(value) if node.nil?

    if value < node.data
      node.left = insert(value, node.left)
    elsif value > node.data
      node.right = insert(value, node.right)
    end
    node
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      temp = find_min(node.right)
      node.data = temp.data
      node.right = delete(temp.data, node.right)
    end
    node
  end

  def find_min(node)
    current = node
    current = current.left while current.left
    current
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value

    if value < node.data
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  def level_order(node = @root, &block)
    return [] if node.nil?

    queue = [node]
    result = []
    until queue.empty?
      current = queue.shift
      block.call(current) if block_given?
      result << current.data
      queue << current.left if current.left
      queue << current.right if current.right
    end
    result unless block_given?
  end

  def inorder(node = @root, &block)
    return [] if node.nil?

    result = []
    result += inorder(node.left, &block) if node.left
    block.call(node) if block_given?
    result << node.data
    result += inorder(node.right, &block) if node.right
    result unless block_given?
  end

  def preorder(node = @root, &block)
    return [] if node.nil?

    result = []
    block.call(node) if block_given?
    result << node.data
    result += preorder(node.left, &block) if node.left
    result += preorder(node.right, &block) if node.right
    result unless block_given?
  end

  def postorder(node = @root, &block)
    return [] if node.nil?

    result = []
    result += postorder(node.left, &block) if node.left
    result += postorder(node.right, &block) if node.right
    block.call(node) if block_given?
    result << node.data
    result unless block_given?
  end

  def height(node)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    [left_height, right_height].max + 1
  end

  def depth(value, node = @root, current_depth = 0)
    return nil if node.nil?
    return current_depth if node.data == value

    if value < node.data
      depth(value, node.left, current_depth + 1)
    else
      depth(value, node.right, current_depth + 1)
    end
  end

  def balanced?(node = @root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    height_diff = (left_height - right_height).abs

    height_diff <= 1 && balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    values = inorder
    @root = build_tree(values)
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true) if node.left
  end
end

# Test
puts 'Creating a binary search tree from random numbers...'
tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print

puts "\nIs the tree balanced?"
puts tree.balanced?

puts "\nLevel order traversal:"
p tree.level_order

puts "\nPreorder traversal:"
p tree.preorder

puts "\nPostorder traversal:"
p tree.postorder

puts "\nInorder traversal:"
p tree.inorder

puts "\nUnbalancing the tree by adding numbers > 100..."
5.times { tree.insert(rand(101..200)) }
tree.pretty_print

puts "\nIs the tree balanced?"
puts tree.balanced?

puts "\nRebalancing the tree..."
tree.rebalance

puts "\nIs the tree balanced?"
puts tree.balanced?

puts "\nLevel order traversal:"
p tree.level_order

puts "\nPreorder traversal:"
p tree.preorder

puts "\nPostorder traversal:"
p tree.postorder

puts "\nInorder traversal:"
p tree.inorder

puts "\nPretty print the tree:"
tree.pretty_print
