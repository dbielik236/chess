# frozen_string_literal: true

# Manages the color and legal moves of the Queens
class Queen
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def legal_move?(start, finish)
    # any number of horizontal, vertical, diagonal squares
  end
end
