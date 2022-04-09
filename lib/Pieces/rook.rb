# frozen_string_literal: true

# Manages the color and legal moves of the Rooks
class Rook
  attr_accessor :color, :icon, :move_count, :name

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0

  end

  def legal_move?(start, finish, starting_piece, ending_piece)
    start_row, start_column = start
    possible_moves = []
    i = 1
    7.times do 
      # Need to figure out how to get if a square is empty or not...
    end


    # castle only if king and rook haven't moved?
  end
end
