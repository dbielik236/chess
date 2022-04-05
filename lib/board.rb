# frozen_string_literal: true

require_relative 'square'
require_relative 'game'

# manages the grid, display, moving pieces, and check(mate)
class Board
  attr_accessor :grid, :starting_piece, :ending_piece

  def initialize
    @starting_piece = nil
    @ending_piece = nil
    @grid = [
      [eight_a = Square.new('8a', @white_rook.icon), eight_b = Square.new('8b'), eight_c = Square.new('8c'), eight_d = Square.new('8d'), eight_e = Square.new('8e'), eight_f = Square.new('8f'), eight_g = Square.new('8g'), eight_h = Square.new('8h')]
    ]
  end

  def display
    puts 'a  b  c  d  e  f  g  h'
    p grid
  end
end
