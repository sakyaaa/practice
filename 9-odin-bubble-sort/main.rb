# frozen_string_literal: true

def bubble_sort(array)
  loop do
    swapped = false

    array.each_with_index do |item, index|
      next unless array[index + 1]
      next unless item > array[index + 1]

      array[index], array[index + 1] = array[index + 1], array[index]
      swapped = true
    end

    break unless swapped
  end

  array
end

loop do
  print 'Enter a list of numbers (1, 2, 3): '
  numbers = gets.chomp.split(', ').map(&:to_i)

  puts bubble_sort(numbers).inspect
end
