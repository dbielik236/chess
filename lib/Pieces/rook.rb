# frozen_string_literal: true

# Manages the color and legal moves of the Rooks
class Rook
  attr_accessor :color, :icon, :move_count, :name

  def initialize(color, icon)
    @color = color
    @icon = icon
    @name = 'rook'
  end

  def legal_move?(start, finish)
    # any number of horizontal, vertical

    # castle only if king and rook haven't moved?
  end
end
