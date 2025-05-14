# frozen_string_literal: true

# Connect four game implementation
class ConnectFour
  attr_reader :board

  def initialize
    @board = Array.new(6) { Array.new(7, nil) }
  end

  def drop_piece(column, piece)
    raise ArgumentError, 'Column is full' if column_full?(column)
    raise ArgumentError, 'Invalid column' unless valid_move?(column)

    row = find_empty_row(column)
    @board[row][column] = piece
  end

  def display_board
    result = " 1   2   3   4   5   6   7\n\n"
    @board.each do |row|
      row.each do |cell|
        result += " #{cell || '⚪'} "
      end
      result += "\n"
    end
    "#{result}\n"
  end

  def valid_move?(column)
    return false if column.negative? || column > 6
    return false if column_full?(column)

    true
  end

  def winner?
    check_horizontal || check_vertical || check_diagonal
  end

  def draw?
    return false if winner?

    @board.all? { |row| row.none?(&:nil?) }
  end

  private

  def column_full?(column)
    @board[0][column] != nil
  end

  def find_empty_row(column)
    (0..5).reverse_each do |row|
      return row if @board[row][column].nil?
    end
  end

  def check_horizontal
    @board.each do |row|
      (0..3).each do |col|
        next if row[col].nil?
        return true if row[col] == row[col + 1] &&
                       row[col] == row[col + 2] &&
                       row[col] == row[col + 3]
      end
    end
    false
  end

  def check_vertical
    (0..6).each do |col|
      (0..2).each do |row|
        next if @board[row][col].nil?
        return true if @board[row][col] == @board[row + 1][col] &&
                       @board[row][col] == @board[row + 2][col] &&
                       @board[row][col] == @board[row + 3][col]
      end
    end
    false
  end

  def check_diagonal
    check_diagonal_up_right || check_diagonal_up_left
  end

  def check_diagonal_up_right
    (0..2).each do |row|
      (0..3).each do |col|
        next if @board[row][col].nil?
        return true if @board[row][col] == @board[row + 1][col + 1] &&
                       @board[row][col] == @board[row + 2][col + 2] &&
                       @board[row][col] == @board[row + 3][col + 3]
      end
    end
    false
  end

  def check_diagonal_up_left
    (0..2).each do |row|
      (3..6).each do |col|
        next if @board[row][col].nil?
        return true if @board[row][col] == @board[row + 1][col - 1] &&
                       @board[row][col] == @board[row + 2][col - 2] &&
                       @board[row][col] == @board[row + 3][col - 3]
      end
    end
    false
  end
end
