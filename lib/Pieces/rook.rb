# frozen_string_literal: true

#  determines color, icon, move count, and legal moves of the Rooks
class Rook
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def moves(start)
    start_row, start_column = start
    possible_moves = []
    # forward
    7.times do
      start_row += 1
      possible_moves << [start_row, start_column]
    end
    # backward
    start_row, start_column = start
    7.times do
      start_row -= 1
      possible_moves << [start_row, start_column]
    end
    # left
    start_row, start_column = start
    7.times do
      start_column -= 1
      possible_moves << [start_row, start_column]
    end
    # right
    start_row, start_column = start
    7.times do
      start_column += 1
      possible_moves << [start_row, start_column]
    end
    possible_moves.include?(finish)

    # castle only if king and rook haven't moved?
  end
end
