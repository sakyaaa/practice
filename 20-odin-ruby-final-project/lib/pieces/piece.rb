# frozen_string_literal: true

# Base class for all chess pieces, defining common behavior and attributes
class Piece
  attr_reader :color
  attr_accessor :position

  def initialize(color, position)
    @color = color
    @position = position
  end

  def moves(board)
    raw_moves(board).reject { |move| board.move_into_check?(position, move) }
  end

  def raw_moves(_board)
    []
  end

  def valid_move?(end_pos, board)
    return false if end_pos.any? { |coord| !coord.between?(0, 7) }
    return false if board[end_pos]&.color == color

    raw_moves(board).include?(end_pos) && !board.move_into_check?(position, end_pos)
  end

  def valid_moves(board)
    raw_moves(board).reject { |move| board.move_into_check?(position, move) }
  end

  def to_s
    symbol
  end

  def attack_squares(board)
    raw_moves(board)
  end

  protected

  def symbol
    raise NotImplementedError, "#{self.class} must implement #symbol"
  end
end
