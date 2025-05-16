# frozen_string_literal: true

# Represents a chess player with their color and name
class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end
