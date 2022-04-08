# frozen_string_literal: true

# Manages the color and legal moves of the Knights
class Knight
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def legal_move?(start, finish, starting_piece, ending_piece)
    start_row, start_column = start
    possible_moves = []

    # up and left
    possible_moves << [start_row + 2, start_column - 1]

    # up and right
    possible_moves << [start_row + 2, start_column + 1]

    # down and left
    possible_moves << [start_row - 2, start_column - 1]

    # down and right
    possible_moves << [start_row - 2, start_column + 1]

    possible_moves.include?(finish)
  end
end
