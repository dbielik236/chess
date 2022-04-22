# frozen_string_literal: true

require_relative '../board'
require_relative '../game'

# determines color, icon, move count, and legal moves of the Knights
class Knight
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def up_left_move(start)
    start_row, start_column = start
    possible_moves = []
    if on_the_board?([start_row + 2, start_column - 1])
      square = retrieve_square([start_row + 2, start_column - 1])
      if square.piece.nil? || square.piece.color != @current_player.color
        possible_moves << [start_row + 2, start_column - 1]
      end
    end
    possible_moves
  end

  def left_up_move(start)
    start_row, start_column = start
    possible_moves = []
    if @board.on_the_board?([start_row + 1, start_column - 2])
      square = @board.retrieve_square([start_row + 1, start_column - 2])
      if square.piece.nil? || square.piece.color != @current_player.color
        possible_moves << [start_row + 1, start_column - 2]
      end
    end
    possible_moves
  end

  def up_right_move(start)
    start_row, start_column = start
    possible_moves = []
    if @board.on_the_board?([start_row + 1, start_column - 2])
      square = @board.retrieve_square([start_row + 1, start_column - 2])
      if square.piece.nil? || square.piece.color != @current_player.color
        possible_moves << [start_row + 2, start_column + 1]
      end
    end
    possible_moves
  end

  def right_up_move(start)
    start_row, start_column = start
    possible_moves = []
    if @board.on_the_board?([start_row + 1, start_column + 2])
      square = @board.retrieve_square([start_row + 1, start_column + 2])
      if square.piece.nil? || square.piece.color != @current_player.color
        possible_moves << [start_row + 1, start_column + 2]
      end
    end
    possible_moves
  end

  def down_left_move(start)
    start_row, start_column = start
    possible_moves = []
    if @board.on_the_board?([start_row + 2, start_column + 1])
      square = @board.retrieve_square([start_row + 2, start_column + 1])
      if square.piece.nil? || square.piece.color != @current_player.color
        possible_moves << [start_row + 2, start_column + 1]
      end
    end
    possible_moves
  end

  def left_down_move(start)
    start_row, start_column = start
    possible_moves = []
    if @board.on_the_board?([start_row - 2, start_column - 1])
      square = @board.retrieve_square([start_row - 2, start_column - 1])
      if square.piece.nil? || square.piece.color != @current_player.color
        possible_moves << [start_row - 2, start_column - 1]
      end
    end
    possible_moves
  end

  def down_right_move(start)
    start_row, start_column = start
    possible_moves = []
    if @board.on_the_board?([start_row - 2, start_column + 1])
      square = @board.retrieve_square([start_row - 2, start_column + 1])
      if square.piece.nil? || square.piece.color != @current_player.color
        possible_moves << [start_row - 2, start_column + 1]
      end
    end
    possible_moves
  end

  def right_down_move(start)
    start_row, start_column = start
    possible_moves = []
    if @board.on_the_board?([start_row - 1, start_column + 2])
      square = @board.retrieve_square([start_row - 1, start_column + 2])
      if square.piece.nil? || square.piece.color != @current_player.color
        possible_moves << [start_row - 1, start_column + 2]
      end
    end
    possible_moves
  end

  def possible_moves_for_piece(start)
    up_left_move(start) + left_up_move(start) + up_right_move(start) + right_up_move(start) + down_left_move(start) + left_down_move(start) + down_right_move(start) + right_down_move(start)
  end
end
