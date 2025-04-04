# frozen_string_literal: true

def stock_picker(prices)
  best_profit = 0
  best_days = [0, 0]

  prices.each_with_index do |buy_price, buy_day|
    prices[buy_day + 1..].each_with_index do |sell_price, sell_day|
      profit = sell_price - buy_price
      if profit > best_profit
        best_profit = profit
        best_days = [buy_day, buy_day + sell_day + 1]
      end
    end
  end

  [best_days, best_profit]
end

loop do
  print 'Enter a list of stock prices (1, 2, 3): '
  prices = gets.chomp.split(', ').map(&:to_i)

  output = stock_picker(prices)
  puts "Best days: #{output[0]} with a profit of #{output[1]}"
end
