# frozen_string_literal: true

# determines color, icon, and legal moves of the Queens
class Queen
  attr_accessor :color, :icon

  def initialize(color, icon)
    @color = color
    @icon = icon
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
      start_column -= 1
      square = @board.retrieve_square([start_row, start_column])
      possible_moves << [start_row, start_column] if square.piece.nil? || square.piece.color != @current_player.color
    end
    possible_moves
  end

  def right_moves(start)
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

  def possible_moves
    left_moves + right_moves + forward_moves + backward_moves + up_left_moves + up_right_moves + down_left_moves + down_right_moves
  end
end
