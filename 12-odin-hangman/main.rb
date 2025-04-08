# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

# Hangman game
class Hangman
  attr_reader :secret_word, :guessed_letters, :incorrect_guesses, :max_attempts

  def initialize
    @max_attempts = 6
    @guessed_letters = []
    @incorrect_guesses = []
    @secret_word = select_secret_word
  end

  def select_secret_word
    words = File.readlines('./12-odin-hangman/google-10000-english-no-swears.txt')
    words.select { |word| word.chomp.length.between?(5, 12) }.sample.chomp
  end

  def display_word
    @secret_word.chars.map do |char|
      @guessed_letters.include?(char) ? char : '_'
    end.join(' ')
  end

  def make_guess(letter)
    letter = letter.downcase
    return false if @guessed_letters.include?(letter) || @incorrect_guesses.include?(letter)

    if @secret_word.include?(letter)
      @guessed_letters << letter
    else
      @incorrect_guesses << letter
    end
    true
  end

  def game_over?
    won? || lost?
  end

  def won?
    @secret_word.chars.all? { |char| @guessed_letters.include?(char) }
  end

  def lost?
    @incorrect_guesses.length >= @max_attempts
  end

  def remaining_attempts
    @max_attempts - @incorrect_guesses.length
  end

  def save_game(filename)
    game_state = {
      secret_word: @secret_word,
      guessed_letters: @guessed_letters,
      incorrect_guesses: @incorrect_guesses
    }
    File.write("./12-odin-hangman/#{filename}.json", JSON.dump(game_state))
  end

  def self.load_game(filename)
    begin
      game_state = JSON.parse(File.read("./12-odin-hangman/#{filename}.json"), symbolize_names: true)
    rescue Errno::ENOENT
      puts 'Error loading game state. Please check the filename and try again.'
      play
    end

    game = new
    game.instance_variable_set(:@secret_word, game_state[:secret_word])
    game.instance_variable_set(:@guessed_letters, game_state[:guessed_letters])
    game.instance_variable_set(:@incorrect_guesses, game_state[:incorrect_guesses])
    game
  end

  def validate_input(input)
    if input.length != 1 || !input.match?(/[a-z]/)
      puts 'Please enter a single character.'
      true
    else
      false
    end
  end

  def check_game_state
    if won?
      puts "Congratulations! You won! The word was: #{@secret_word}"
    elsif lost?
      puts "Game Over! The word was: #{@secret_word}"
    end
  end

  def handle_guess(input)
    return true if input == 'save' && save_current_game
    return true if validate_input(input)

    if make_guess(input)
      check_game_state
    else
      puts "You've already guessed that letter!"
    end
    false
  end

  def save_current_game
    puts 'Enter name for save file: '
    save_game(gets.chomp)
    puts 'Game saved!'
    true
  end

  def display_state
    puts "\nWord: #{display_word}"
    puts "Incorrect guesses: #{@incorrect_guesses.join(', ')}"
    puts "Remaining attempts: #{remaining_attempts}"
  end

  def self.download_dictionary
    url = URI('https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt')
    response = Net::HTTP.get_response(url)
    File.write('./12-odin-hangman/google-10000-english-no-swears.txt', response.body)
  end

  def self.ensure_dictionary
    return if File.exist?('./12-odin-hangman/google-10000-english-no-swears.txt')

    puts 'Downloading dictionary...'
    download_dictionary
  end

  def self.play
    ensure_dictionary

    puts 'Welcome to Hangman!'
    puts '1. New Game'
    puts '2. Load Game'
    choice = gets.chomp

    game = if choice == '2'
             puts 'Enter the name of your saved game:'
             load_game(gets.chomp)
           elsif choice == '1'
             new
           else
             puts 'Invalid choice. Please try again.'
             Hangman.play
           end

    until game.game_over?
      game.display_state
      puts "\nEnter a letter to guess, or 'save' to save the game:"
      next if game.handle_guess(gets.chomp.downcase)
    end

    puts 'Would you like to play again? (y/n)'
    if gets.chomp.downcase == 'y'
      Hangman.play
    else
      puts 'Goodbye!'
    end
  end
end

Hangman.play
