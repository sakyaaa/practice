# frozen_string_literal: true

# Tic Tac Toe game
class TicTacToe
  def initialize
    @board = Array.new(3) { Array.new(3, ' ') }
    @current_player = 'X'
  end

  def play
    loop do
      display_board
      player_move
      if win? || draw?
        display_board
        puts game_result
        break
      end
      switch_player
    end
  end

  private

  def display_board
    puts "\n"
    @board.each_with_index do |row, i|
      puts " #{row[0]} | #{row[1]} | #{row[2]} "
      puts '-----------' unless i == 2
    end
    puts "\n"
  end

  def player_move
    loop do
      puts "Player #{@current_player}, enter your move (1-9):"
      position = gets.chomp.to_i
      if valid_move?(position)
        make_move(position)
        break
      else
        puts 'Invalid move. Please try again.'
      end
    end
  end

  def valid_move?(position)
    return false unless position.between?(1, 9)

    row = (position - 1) / 3
    col = (position - 1) % 3
    @board[row][col] == ' '
  end

  def make_move(position)
    row = (position - 1) / 3
    col = (position - 1) % 3
    @board[row][col] = @current_player
  end

  def switch_player
    @current_player = @current_player == 'X' ? 'O' : 'X'
  end

  def game_over?
    win? || draw?
  end

  def win?
    check_rows || check_columns || check_diagonals
  end

  def check_rows
    @board.any? { |row| row.all? { |cell| cell == @current_player } }
  end

  def check_columns
    (0..2).any? { |col| @board.all? { |row| row[col] == @current_player } }
  end

  def check_diagonals
    main_diagonal = @board[0][0] == @current_player && @board[1][1] == @current_player && @board[2][2] == @current_player
    anti_diagonal = @board[0][2] == @current_player && @board[1][1] == @current_player && @board[2][0] == @current_player

    main_diagonal || anti_diagonal
  end

  def draw?
    @board.flatten.none? { |cell| cell == ' ' }
  end

  def game_result
    if win?
      "Player #{@current_player} wins!"
    else
      "It's a draw!"
    end
  end
end

TicTacToe.new.play
