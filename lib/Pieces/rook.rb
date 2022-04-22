# frozen_string_literal: true

require_relative '../board'
require_relative '../game'

#  determines color, icon, move count, and legal moves of the Rooks
class Rook
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def forward_moves(start)
    start_row, start_column = start
    possible_moves = []
    until !@board.on_the_board?([start_row, start_column]) ||
          @board.retrieve_square([start_row, start_column]).piece.color == @current_player.color
      start_row += 1
      square = @board.retrieve_square([start_row, start_column])
      possible_moves << [start_row, start_column] if square.piece.nil? || square.piece.color != @current_player.color
    end
    possible_moves
  end

  def backward_moves(start)
    start_row, start_column = start
    possible_moves = []
    until !@board.on_the_board?([start_row, start_column]) ||
          @board.retrieve_square([start_row, start_column]).piece.color == @current_player.color
      start_row -= 1
      square = @board.retrieve_square([start_row, start_column])
      possible_moves << [start_row, start_column] if square.piece.nil? || square.piece.color != @current_player.color
    end
    possible_moves
  end

  def left_moves(start)
    start_row, start_column = start
    possible_moves = []
    until !@board.on_the_board?([start_row, start_column]) ||
          @board.retrieve_square([start_row, start_column]).piece.color == @current_player.color
      start_column += 1
      square = @board.retrieve_square([start_row, start_column])
      possible_moves << [start_row, start_column] if square.piece.nil? || square.piece.color != @current_player.color
    end
    possible_moves
  end

  def right_moves(start)
    start_row, start_column = start
    possible_moves = []
    until !@board.on_the_board?(start_row, start_column) || @board.retrieve_square.piece.color == @current_player.color
      start_column += 1
      if @board.retrieve_square.piece.nil? || @board.retrieve_square.piece.color != @current_player.color
        possible_moves << [start_row, start_column]
      end
    end
    possible_moves
  end

  def possible_moves
    left_moves + right_moves + forward_moves + backward_moves
  end
end
