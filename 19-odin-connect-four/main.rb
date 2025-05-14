# frozen_string_literal: true

require_relative 'lib/connect_four'

def get_player_move(player, game)
  loop do
    print "#{player}'s turn. Enter column (1-7): "
    input = gets.chomp.strip

    exit if input.downcase == 'q'

    begin
      column = input.to_i - 1
      return column if game.valid_move?(column)

      puts 'Invalid move! Please enter a number between 1 and 7 for an empty column.'
    rescue ArgumentError => e
      puts "Error: #{e.message}"
    end
  end
end

def play_game
  game = ConnectFour.new
  players = ['🔴', '🔵']
  current_player = 0

  puts "\nWelcome to Connect Four!"
  puts "Enter 'q' at any time to quit the game."
  puts "Players: #{players[0]} vs #{players[1]}"
  puts "\nPress Enter to start..."
  gets

  loop do
    system 'clear'
    puts "\n#{game.display_board}"

    begin
      column = get_player_move(players[current_player], game)
      game.drop_piece(column, players[current_player])

      if game.winner?
        puts "\n#{game.display_board}"
        puts "#{players[current_player]} wins!"
        break
      elsif game.draw?
        puts "\n#{game.display_board}"
        puts "It's a draw!"
        break
      end

      current_player = (current_player + 1) % 2
    rescue ArgumentError => e
      puts "Error: #{e.message}"
      puts 'Press Enter to continue...'
      gets
    end
  end
end

play_game
