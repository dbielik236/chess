# frozen_string_literal: true

require_relative "game"
require_relative "board"

# Manages the color and legal moves of the Pawns
class Pawn
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def legal_move?(start, finish)
    # 1 square foward

    # 2 squares forward only if move_count == 0

    # diagonal forward only when attacking

    # en passant only if... ?
  end    
end
  