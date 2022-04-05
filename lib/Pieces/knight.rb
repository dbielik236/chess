# frozen_string_literal: true

# Manages the color and legal moves of the Knights
class Knight
  attr_accessor :color, :icon, :move_count
  
  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def legal_move?(start, finish)
    # 2 up/down and 1 left/right or
    # 1 up/down and 2 left/right
  end
end
  