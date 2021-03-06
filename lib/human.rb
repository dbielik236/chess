# frozen_string_literal: true

# establishes player's name and color choice
class Player
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end
