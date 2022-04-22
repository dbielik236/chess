# frozen_string_literal: true

require_relative '../board'
require_relative '../game'

# determines color, icon, move count, and legal moves of the Bishops
class Bishop
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def up_right_moves(start)
    start_row, start_column = start
    possible_moves = []
    until !@board.on_the_board?([start_row, start_column]) ||
          @board.retrieve_square([start_row, start_column]).piece.color == @current_player.color
      start_row += 1
      start_column += 1
      square = @board.retrieve_square([start_row, start_column])
      possible_moves << [start_row, start_column] if square.piece.nil? || square.piece.color != @current_player.color
    end
    possible_moves
  end

  def up_left_moves(start)
    start_row, start_column = start
    possible_moves = []
    until !@board.on_the_board?([start_row, start_column]) ||
          @board.retrieve_square([start_row, start_column]).piece.color == @current_player.color
      start_row += 1
      start_column -= 1
      square = @board.retrieve_square([start_row, start_column])
      possible_moves << [start_row, start_column] if square.piece.nil? || square.piece.color != @current_player.color
    end
    possible_moves
  end

  def down_right_moves(start)
    start_row, start_column = start
    possible_moves = []
    until !@board.on_the_board?([start_row, start_column]) ||
          @board.retrieve_square([start_row, start_column]).piece.color == @current_player.color
      start_row -= 1
      start_column += 1
      square = @board.retrieve_square([start_row, start_column])
      possible_moves << [start_row, start_column] if square.piece.nil? || square.piece.color != @current_player.color
    end
    possible_moves
  end

  def down_left_moves(start)
    start_row, start_column = start
    possible_moves = []
    until !@board.on_the_board?([start_row, start_column]) ||
          @board.retrieve_square([start_row, start_column]).piece.color == @current_player.color
      start_row -= 1
      start_column -= 1
      square = @board.retrieve_square([start_row, start_column])
      possible_moves << [start_row, start_column] if square.piece.nil? || square.piece.color != @current_player.color
    end
    possible_moves
  end

  def possible_moves_for_piece(start)
    up_left_moves(start) + up_right_moves(start) + down_left_moves(start) + downn_right_moves(start)
  end
end
