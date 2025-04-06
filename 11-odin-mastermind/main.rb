# frozen_string_literal: true

# Mastermind game
class Mastermind
  def initialize
    @attempts = 12
    @guesses = []
    @possible_codes = (1..6).to_a.repeated_permutation(4).to_a
  end

  def play
    puts 'Welcome to Mastermind!'
    puts 'Would you like to be the code maker (1) or code breaker (2)?'
    role = role_choice

    if role == 1
      @code = human_code
      computer_play
    else
      @code = Array.new(4) { rand(1..6) }
      human_play
    end
  end

  private

  def role_choice
    loop do
      choice = gets.chomp.to_i
      return choice if [1, 2].include?(choice)

      puts 'Please enter 1 to be the code maker or 2 to be the code breaker.'
    end
  end

  def human_code
    puts 'Enter your secret code (4 numbers between 1 and 6):'
    valid_guess
  end

  def human_play
    puts "You have #{@attempts} attempts to guess the code."
    puts 'The code is a sequence of 4 numbers between 1 and 6.'
    puts 'For example: 1234'

    @attempts.times do |attempt|
      puts "\nAttempt #{attempt + 1}/#{@attempts}"
      puts 'Enter your guess:'
      guess = valid_guess
      @guesses << guess

      feedback = evaluate_guess(guess)
      display_feedback(feedback)

      if guess == @code
        puts "\nCongratulations! You've cracked the code!"
        break
      end
    end

    puts "\nGame Over! The code was: #{@code.join}"
  end

  def computer_play
    puts "\nComputer will now try to guess your code."
    puts "You have #{@attempts} attempts to guess the code."
    puts 'The code is a sequence of 4 numbers between 1 and 6.'
    puts 'For example: 1234'

    @attempts.times do |attempt|
      puts "\nAttempt #{attempt + 1}/#{@attempts}"
      guess = computer_guess
      puts "Computer's guess: #{guess.join}"

      feedback = evaluate_guess(guess)
      display_feedback(feedback)

      if guess == @code
        puts "\nThe computer has cracked your code!"
        break
      end

      update_possible_codes(guess, feedback)
    end

    puts "\nGame Over! The computer failed to crack your code: #{@code.join}"
  end

  def computer_guess
    @possible_codes.sample
  end

  def update_possible_codes(guess, feedback)
    @possible_codes.select! do |code|
      evaluate_guess(guess, code) == feedback
    end
  end

  def evaluate_guess(guess, code = @code)
    exact_matches = guess.each_with_index.count { |g, i| g == code[i] }
    total_matches = guess.uniq.sum { |g| [guess.count(g), code.count(g)].min }
    color_matches = total_matches - exact_matches

    { exact: exact_matches, color: color_matches }
  end

  def valid_guess
    loop do
      input = gets.chomp
      return input.chars.map(&:to_i) if input.match?(/^[1-6]{4}$/)

      puts 'Invalid input! Please enter 4 numbers between 1 and 6.'
    end
  end

  def display_feedback(feedback)
    puts "Exact matches: #{feedback[:exact]}"
    puts "Color matches: #{feedback[:color]}"
  end
end

loop do
  Mastermind.new.play
  puts 'Would you like to play again? (y/n)'
  break unless gets.chomp.downcase == 'y'
end
