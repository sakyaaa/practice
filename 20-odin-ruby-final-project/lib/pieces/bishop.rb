# frozen_string_literal: true

require_relative 'piece'

# Represents a bishop piece with its diagonal movement rules
class Bishop < Piece
  def raw_moves(board)
    moves = []
    row, col = position
    directions = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    directions.each do |dr, dc|
      r = row + dr
      c = col + dc
      while (0..7).cover?(r) && (0..7).cover?(c)
        if board[[r, c]].nil?
          moves << [r, c]
        else
          moves << [r, c] if board[[r, c]].color != color
          break
        end
        r += dr
        c += dc
      end
    end
    moves
  end

  def attack_squares(board)
    raw_moves(board)
  end

  protected

  def symbol
    color == :black ? '♗' : '♝'
  end
end
