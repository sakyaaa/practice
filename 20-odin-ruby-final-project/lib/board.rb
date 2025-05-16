# frozen_string_literal: true

# Represents the chess board, managing piece positions and board state
class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_board
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

  def get_piece(pos)
    self[pos]
  end

  def move_piece(from_pos, to_pos)
    piece = self[from_pos]
    self[to_pos] = piece
    self[from_pos] = nil
    piece.position = to_pos
  end

  def in_check?(color)
    king_pos = find_king(color)
    opponent_pieces = pieces.reject { |piece| piece.color == color }
    opponent_pieces.any? do |piece|
      piece.attack_squares(self).include?(king_pos)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    pieces.select { |piece| piece.color == color }.none? do |piece|
      piece.moves(self).any?
    end
  rescue RuntimeError => e
    return true if e.message.include?("No #{color} king found")

    raise e
  end

  def stalemate?(color)
    return false if in_check?(color)

    pieces.select { |piece| piece.color == color }.none? do |piece|
      piece.moves(self).any?
    end
  end

  def pieces
    grid.flatten.compact
  end

  def move_into_check?(from_pos, to_pos)
    piece = self[from_pos]
    return false if piece.nil?

    simulate_move(from_pos, to_pos) { in_check?(piece.color) }
  end

  def to_s
    display = "  a b c d e f g h\n"
    grid.each_with_index do |row, i|
      display += "#{8 - i} "
      row.each do |piece|
        display += piece ? piece.to_s : '·'
        display += ' '
      end
      display += "#{8 - i}\n"
    end
    "#{display}  a b c d e f g h"
  end

  private

  def setup_board
    setup_pawns
    setup_back_row
  end

  def setup_pawns
    [1, 6].each do |row|
      color = row == 1 ? :black : :white
      8.times do |col|
        self[[row, col]] = Pawn.new(color, [row, col])
      end
    end
  end

  def setup_back_row
    [0, 7].each do |row|
      color = row.zero? ? :black : :white
      pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      pieces.each_with_index do |piece_class, col|
        self[[row, col]] = piece_class.new(color, [row, col])
      end
    end
  end

  def find_king(color)
    king = pieces.find { |piece| piece.is_a?(King) && piece.color == color }
    raise "No #{color} king found on the board!" if king.nil?

    king.position
  end

  def simulate_move(from_pos, to_pos)
    piece = self[from_pos]
    return false if piece.nil?

    captured = self[to_pos]
    old_pos = piece.position.dup
    self[to_pos] = piece
    self[from_pos] = nil
    piece.position = to_pos
    begin
      result = yield
    ensure
      self[from_pos] = piece
      self[to_pos] = captured
      piece.position = old_pos
      captured&.position = to_pos
    end
    result
  end

  def king_in_check?(king, pos)
    opponent_pieces = pieces.reject { |p| p.color == king.color }
    opponent_pieces.any? do |opponent|
      if opponent.is_a?(King)
        (opponent.position[0] - pos[0]).abs <= 1 && (opponent.position[1] - pos[1]).abs <= 1
      else
        opponent.raw_moves(self).include?(pos)
      end
    end
  end
end
