# frozen_string_literal: true

# determines color, icon, move count, and legal moves of the Kings
class King
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def legal_move?(start, finish, starting_piece, ending_piece)
    start_row, start_column = start
    possible_moves = []
    # forward
    possible_moves << [start_row + 1, start_column]
    # backward
    possible_moves << [start_row - 1, start_column]
    # left
    possible_moves << [start_row, start_column - 1]
    # right
    possible_moves << [start_row, start_column + 1]
    # up left
    possible_moves << [start_row + 1, start_column - 1]
    # up right
    possible_moves << [start_row + 1, start_column + 1]
    # down left
    possible_moves << [start_row - 1, start_column - 1]
    # down right
    possible_moves << [start_row - 1, start_column + 1]
    possible_moves.include?(finish)
  end
end
