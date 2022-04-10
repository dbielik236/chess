# frozen_string_literal: true

# determines color, icon, move count, and legal moves of the Knights
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

    # up 2 and left 1
    possible_moves << [start_row + 2, start_column - 1]

    # up 1 and left 2
    possible_moves << [start_row + 1, start_column - 2]

    # up 2 and right 1
    possible_moves << [start_row + 2, start_column + 1]

    # up 1 and right 2
    possible_moves << [start_row + 1, start_column + 2]

    # down 2 and left 1
    possible_moves << [start_row - 2, start_column - 1]

    # down 1 and left 2
    possible_moves << [start_row - 1, start_column - 2]

    # down 2 and right 1
    possible_moves << [start_row - 2, start_column + 1]

    # down 1 and right 2
    possible_moves << [start_row - 1, start_column + 2]

    possible_moves.include?(finish)
  end
end
