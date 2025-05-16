# frozen_string_literal: true

require_relative 'piece'

# Represents a knight piece with its L-shaped movement rules
class Knight < Piece
  def raw_moves(board)
    moves = []
    row, col = position
    jumps = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    jumps.each do |dr, dc|
      r = row + dr
      c = col + dc
      next unless (0..7).cover?(r) && (0..7).cover?(c)
      next if board[[r, c]] && board[[r, c]].color == color

      moves << [r, c]
    end
    moves
  end

  def attack_squares(board)
    raw_moves(board)
  end

  protected

  def symbol
    color == :black ? '♘' : '♞'
  end
end
