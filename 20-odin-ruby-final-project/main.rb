# frozen_string_literal: true

require_relative 'lib/player'
require_relative 'lib/pieces/piece'
require_relative 'lib/pieces/pawn'
require_relative 'lib/pieces/knight'
require_relative 'lib/pieces/bishop'
require_relative 'lib/pieces/rook'
require_relative 'lib/pieces/queen'
require_relative 'lib/pieces/king'
require_relative 'lib/board'
require_relative 'lib/game'

if __FILE__ == $PROGRAM_NAME
  puts 'Welcome to Chess!'
  puts 'Would you like to:'
  puts '1. Start a new game'
  puts '2. Load a saved game'

  choice = gets.chomp.to_i

  game = choice == 2 ? Game.load_game : Game.new

  game.play
end
