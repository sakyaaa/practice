# frozen_string_literal: true

require_relative 'piece'

# Represents a king piece with its one-square movement rules
class King < Piece
  def moves(board)
    raw_moves(board).reject { |move| board.move_into_check?(position, move) }
  end

  def raw_moves(board)
    row, col = position
    adjacent_positions(row, col).select { |pos| valid_position?(pos, board) }
  end

  def attack_squares(_board)
    row, col = position
    adjacent_positions(row, col).select { |pos| (0..7).cover?(pos[0]) && (0..7).cover?(pos[1]) }
  end

  protected

  def symbol
    color == :black ? '♔' : '♚'
  end

  private

  def adjacent_positions(row, col)
    positions = []
    (-1..1).each do |dr|
      (-1..1).each do |dc|
        next if dr.zero? && dc.zero?

        positions << [row + dr, col + dc]
      end
    end
    positions
  end

  def valid_position?(pos, board)
    row, col = pos
    return false unless row.between?(0, 7) && col.between?(0, 7)

    piece = board[pos]
    piece.nil? || piece.color != color
  end

  def would_be_in_check?(pos, board)
    original_pos = position
    original_piece = board[pos]

    board[pos] = self
    board[original_pos] = nil
    self.position = pos

    in_check = board.pieces.reject { |p| p.color == color }.any? do |piece|
      if piece.is_a?(King)
        piece_pos = piece.position
        (piece_pos[0] - pos[0]).abs <= 1 && (piece_pos[1] - pos[1]).abs <= 1
      else
        piece.raw_moves(board).include?(pos)
      end
    end

    board[original_pos] = self
    board[pos] = original_piece
    self.position = original_pos

    in_check
  end
end
