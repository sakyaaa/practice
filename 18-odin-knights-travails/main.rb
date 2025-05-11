# frozen_string_literal: true

# Knight implementation
class Knight
  def initialize
    @board_size = 8
  end

  def knight_moves(start_pos, end_pos)
    return nil unless valid_position?(start_pos) && valid_position?(end_pos)

    return [start_pos] if start_pos == end_pos

    queue = [[start_pos, [start_pos]]]
    visited = Set.new([start_pos])

    until queue.empty?
      current_pos, path = queue.shift

      possible_moves = get_possible_moves(current_pos)

      possible_moves.each do |move|
        next if visited.include?(move)

        return path + [move] if move == end_pos

        visited.add(move)
        queue << [move, path + [move]]
      end
    end

    nil
  end

  private

  def valid_position?(pos)
    x, y = pos
    x.between?(0, @board_size - 1) && y.between?(0, @board_size - 1)
  end

  def get_possible_moves(pos)
    x, y = pos
    moves = []

    [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [1, 2], [1, -2], [-1, 2], [-1, -2]
    ].each do |dx, dy|
      new_x = x + dx
      new_y = y + dy
      moves << [new_x, new_y] if valid_position?([new_x, new_y])
    end

    moves
  end
end

def print_path(path)
  puts "You made it in #{path.length - 1} moves! Here's your path:"
  path.each { |pos| puts pos.inspect }
end

# Tests
knight = Knight.new

puts 'Test 1: Simple move from [0,0] to [1,2]'
print_path(knight.knight_moves([0, 0], [1, 2]))

puts "\n"

puts 'Test 2: Multiple moves from [0,0] to [3,3]'
print_path(knight.knight_moves([0, 0], [3, 3]))

puts "\n"

puts 'Test 3: Long path from [0,0] to [7,7]'
print_path(knight.knight_moves([0, 0], [7, 7]))
