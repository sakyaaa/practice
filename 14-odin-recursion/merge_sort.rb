# frozen_string_literal: true

def merge_sort(array)
  return array unless array.length > 1

  mid = array.length / 2
  left = merge_sort(array[0...mid])
  right = merge_sort(array[mid..])

  merge(left, right)
end

private

def merge(left, right)
  result = []
  result << (left.first <= right.first ? left.shift : right.shift) until left.empty? || right.empty?
  result + left + right
end
