# frozen_string_literal: true

require 'yaml'

# Manages the chess game flow, including turns, moves, and game state
class Game
  attr_reader :board, :players, :current_player

  def initialize
    @board = Board.new
    @players = [
      Player.new('White', :white),
      Player.new('Black', :black)
    ]
    @current_player = @players[0]
  end

  def play
    loop do
      display_board
      break if game_over?

      puts "\n#{current_player.name}'s turn"
      puts "Enter your move (e.g., 'e2 e4') or 'save' to save the game:"
      move = gets.chomp.downcase

      if move == 'save'
        save_game
        next
      end

      if valid_move?(move)
        make_move(move)
        switch_player
      else
        puts 'Invalid move! Try again.'
      end
    end
  end

  def self.load_game
    if File.exist?('saved_game.yaml')
      begin
        YAML.safe_load_file('saved_game.yaml',
                            permitted_classes: [Game, Board, Player, Piece, Pawn, Knight, Bishop, Rook, Queen, King,
                                                Symbol],
                            aliases: true)
      rescue StandardError => e
        puts "Error loading saved game: #{e.message}"
        puts 'Starting new game.'
        new
      end
    else
      puts 'No saved game found. Starting new game.'
      new
    end
  end

  def display_board
    puts "\n#{board}"
  end

  def valid_move?(move)
    return false unless move.match?(/^[a-h][1-8] [a-h][1-8]$/)

    from_pos, to_pos = move.split.map { |pos| convert_to_coordinates(pos) }
    piece = board.get_piece(from_pos)

    piece && piece.color == current_player.color && piece.valid_move?(to_pos, board)
  end

  private

  def make_move(move)
    from_pos, to_pos = move.split.map { |pos| convert_to_coordinates(pos) }
    board.move_piece(from_pos, to_pos)
  end

  def convert_to_coordinates(pos)
    col = pos[0].ord - 'a'.ord
    row = 8 - pos[1].to_i
    [row, col]
  end

  def switch_player
    @current_player = current_player == players[0] ? players[1] : players[0]
  end

  def game_over?
    if board.checkmate?(current_player.color)
      puts "\nCheckmate! #{opponent.name} wins!"
      true
    elsif board.stalemate?(current_player.color)
      puts "\nStalemate! The game is a draw."
      true
    else
      false
    end
  end

  def opponent
    current_player == players[0] ? players[1] : players[0]
  end

  def save_game
    File.write('saved_game.yaml', YAML.dump(self))
    puts 'Game saved!'
  rescue StandardError => e
    puts "Error saving game: #{e.message}"
  end
end
