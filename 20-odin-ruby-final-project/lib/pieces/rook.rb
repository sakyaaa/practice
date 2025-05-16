# frozen_string_literal: true

require_relative 'piece'

# Represents a rook piece with its horizontal and vertical movement rules
class Rook < Piece
  def raw_moves(board)
    moves = []
    row, col = position
    directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
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
    color == :black ? '♖' : '♜'
  end

  private

  def path_clear?(board, end_pos)
    row, col = position
    end_row, end_col = end_pos

    if row == end_row
      # Horizontal movement
      min_col, max_col = [col, end_col].minmax
      (min_col + 1...max_col).each do |c|
        return false unless board[[row, c]].nil?
      end
    else
      # Vertical movement
      min_row, max_row = [row, end_row].minmax
      (min_row + 1...max_row).each do |r|
        return false unless board[[r, col]].nil?
      end
    end

    true
  end
end
