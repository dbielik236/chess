# frozen_string_literal: true

require_relative '../board'

# Manages the color and legal moves of the Pawns
class Pawn
  attr_accessor :color, :icon, :move_count

  def initialize(color, icon)
    @color = color
    @icon = icon
    @move_count = 0
  end

  def legal_move?(start, finish, starting_piece, ending_piece)
    start_row, start_column = start

    # for white pawns
    if starting_piece.color == 'white'
      possible_moves = []

      # allows the pawn to move forward one if the spot is open
      possible_moves << [start_row.to_i + 1, start_column] if ending_piece.nil?

      # allows the pawn to move
      possible_moves << [start_row + 2, start_column] if starting_piece.move_count.zero?

      # allows the pawn to capture another one
      possible_moves << [start_row + 1, start_column + 1] unless ending_piece.nil?
      possible_moves << [start_row + 1, start_column - 1] unless ending_piece.nil?

      # en passant only if... (needs to be added)?
      possible_moves.include?(finish)

    elsif starting_piece.color == 'black'
      possible_moves = []

      # allows the pawn to move forward one if the spot is open
      possible_moves << [start_row.to_i - 1, start_column] if ending_piece.nil?

      # allows the pawn to move
      possible_moves << [start_row - 2, start_column] if starting_piece.move_count.zero?

      # allows the pawn to capture another one
      possible_moves << [start_row + 1, start_column + 1] unless ending_piece.nil?
      possible_moves << [start_row + 1, start_column - 1] unless ending_piece.nil?

      # en passant only if... (needs to be added)?
      possible_moves.include?(finish)
    end
  end
end
