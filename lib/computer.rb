# frozen_string_literal: true

# establishes human's name and color choice
class Computer
  attr_accessor :name, :color

  def initialize(color)
    @color = color
    @name = 'The computer'
  end
end
