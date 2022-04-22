# frozen_string_literal: true

require_relative '../board'
require_relative '../game'

# determines color, icon, move count, and legal moves of the Kings
class King
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def forward_move(start)
    start_row, start_column = start
    possible_moves = []
    square = @board.retrieve_square([start_row + 1, start_column])
    if square.piece.nil? || square.piece.color != @current_player.color
      possible_moves << [start_row + 1, start_column]
    end
    possible_moves
  end

  def backward_move(start)
    start_row, start_column = start
    possible_moves = []
    square = @board.retrieve_square([start_row - 1, start_column])
    if square.piece.nil? || square.piece.color != @current_player.color
      possible_moves << [start_row - 1, start_column] 
    end
    possible_moves
  end

  def left_move(start)
    start_row, start_column = start
    possible_moves = []
    square = @board.retrieve_square([start_row, start_column - 1])
    if square.piece.nil? || square.piece.color != @current_player.color
      possible_moves << [start_row, start_column - 1]
    end
    possible_moves
  end

  def right_move(start)
    start_row, start_column = start
    possible_moves = []
    square = @board.retrieve_square([start_row, start_column + 1])
    if square.piece.nil? || square.piece.color != @current_player.color
      possible_moves << [start_row, start_column + 1]
    end
    possible_moves
  end

  def up_left_move(start)
    start_row, start_column = start
    possible_moves = []
    square = @board.retrieve_square([start_row + 1, start_column - 1])
    if square.piece.nil? || square.piece.color != @current_player.color
      possible_moves << [start_row + 1, start_column - 1]
    end
    possible_moves
  end

  def up_right_move(start)
    start_row, start_column = start
    possible_moves = []
    square = @board.retrieve_square([start_row + 1, start_column + 1])
    if square.piece.nil? || square.piece.color != @current_player.color
      possible_moves << [start_row + 1, start_column + 1]
    end
    possible_moves
  end

  def down_left_move(start)
    start_row, start_column = start
    possible_moves = []
    square = @board.retrieve_square([start_row - 1, start_column - 1])
    if square.piece.nil? || square.piece.color != @current_player.color
      possible_moves << [start_row - 1, start_column - 1]
    end
    possible_moves
  end

  def down_right_move(start)
    start_row, start_column = start
    possible_moves = []
    square = @board.retrieve_square([start_row - 1, start_column + 1])
    if square.piece.nil? || square.piece.color != @current_player.color
      possible_moves << [start_row - 1, start_column + 1]
    end
    possible_moves
  end

  def possible_moves_for_piece(start)
    forward_move(start) + backward_move(start) + up_left_move(start) + up_right_move(start) + down_left_move(start) + down_right_move(start)
  end
end
