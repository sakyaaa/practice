# frozen_string_literal: true

# For each word in the string named word, count how many times it appears in the dictionary.
def substrings(word, dictionary)
  result = Hash.new(0)
  words = word.downcase.split(/\W+/)

  words.each do |desired|
    dictionary.each do |substring|
      count = desired.scan(substring.downcase).length
      result[substring] += count if count.positive?
    end
  end

  result.sort.to_h
end

loop do
  print 'Enter a desired word: '
  word = gets.chomp

  print 'Enter a dictionary (a, b, c): '
  dictionary = gets.chomp.split(', ')

  puts substrings(word, dictionary)
end
