# frozen_string_literal: true

# establishes human's name and color choice
class Human
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end
