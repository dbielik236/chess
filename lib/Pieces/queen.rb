# frozen_string_literal: true

# determines color, icon, move count, and legal moves of the Queens
class Queen
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def possible_moves(start)
    start_row, start_column = start
    possible_moves = []
    # up right diagonal
    7.times do
      start_row += 1
      start_column += 1
      possible_moves << [start_row, start_column]
    end
    # up left diagonal
    start_row, start_column = start
    7.times do
      start_row += 1
      start_column -= 1
      possible_moves << [start_row, start_column]
    end
    # down right diagonal
    start_row, start_column = start
    7.times do
      start_row -= 1
      start_column += 1
      possible_moves << [start_row, start_column]
    end
    # down left diagonal
    start_row, start_column = start
    7.times do
      start_row -= 1
      start_column -= 1
      possible_moves << [start_row, start_column]
    end
    # forward
    start_row, start_column = start
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
    possible_moves
  end
end
