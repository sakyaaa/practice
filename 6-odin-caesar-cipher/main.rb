# frozen_string_literal: true

def caesar_cipher(string, shift, result = '')
  alphabet = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z].freeze
  shift = shift.to_i

  string.chars.each do |symbol|
    if alphabet.include?(symbol.downcase)
      array_index = alphabet.find_index(symbol.downcase)
      array_index += alphabet.length while (array_index - shift).negative?
      result += symbol == symbol.upcase ? alphabet[array_index - shift].upcase : alphabet[array_index - shift]
    else
      result += symbol
    end
  end

  result
end

loop do
  print 'Enter string: '
  string = gets.chomp

  print 'Enter shift: '
  shift = gets.chomp

  puts caesar_cipher(string, shift)
end
