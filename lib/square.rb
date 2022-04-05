# frozen_string_literal: true

# This allows each square on the board to hold its own information
class Square
  attr_accessor :location, :piece

  def initialize(location, piece = nil)
    @location = location
    @piece = piece
  end
end
