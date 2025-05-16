# frozen_string_literal: true

require_relative 'piece'
require_relative 'queen'

# Represents a pawn piece with its specific movement and capture rules
class Pawn < Piece
  def raw_moves(board)
    moves = forward_moves(board) + capture_moves(board)
    moves.each { |move| promote_pawn(board, move) if should_promote?(move[0]) }
    moves
  end

  def attack_squares(_board)
    row, col = position
    direction = color == :white ? -1 : 1
    squares = []
    [[-1, direction], [1, direction]].each do |dc|
      pos = [row + dc[1], col + dc[0]]
      squares << pos if pos.all? { |coord| coord.between?(0, 7) }
    end
    squares
  end

  protected

  def symbol
    color == :black ? '♙' : '♟'
  end

  private

  def forward_moves(board)
    moves = []
    row, col = position
    direction = color == :white ? -1 : 1

    forward = [row + direction, col]
    return moves unless board[forward].nil?

    moves << forward
    moves << [row + (2 * direction), col] if can_move_double?(row) && board[[row + (2 * direction), col]].nil?
    moves
  end

  def capture_moves(board)
    moves = []
    row, col = position
    direction = color == :white ? -1 : 1

    [[-1, 1], [1, 1]].each do |dc|
      capture_pos = [row + direction, col + dc[0]]
      if capture_pos.all? { |coord| coord.between?(0, 7) }
        piece = board[capture_pos]
        moves << capture_pos if piece && piece.color != color
      end
    end
    moves
  end

  def can_move_double?(row)
    (color == :white && row == 6) || (color == :black && row == 1)
  end

  def should_promote?(row)
    (color == :white && row.zero?) || (color == :black && row == 7)
  end

  def promote_pawn(board, pos)
    return unless should_promote?(pos[0])

    board[pos] = Queen.new(color, pos)
  end
end
