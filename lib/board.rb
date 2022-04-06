# frozen_string_literal: true

require_relative 'square'
require_relative './pieces/rook'

# manages the grid, display, moving pieces, and check(mate)
class Board
  attr_accessor :grid, :starting_piece, :ending_piece

  def initialize
    @color = 46
    @white_rook = Rook.new('white', '♖')
    @black_rook = Rook.new('black', '♜')
    @starting_piece = nil
    @ending_piece = nil
    @grid = [
      [Square.new('8a', @white_rook), Square.new('8b', @black_rook), eight_c = Square.new('8c'), eight_d = Square.new('8d'), eight_e = Square.new('8e'), eight_f = Square.new('8f'), eight_g = Square.new('8g'), eight_h = Square.new('8h')], 
      [Square.new('8a', @white_rook), Square.new('8b'), eight_c = Square.new('8c'), eight_d = Square.new('8d'), eight_e = Square.new('8e'), eight_f = Square.new('8f'), eight_g = Square.new('8g'), eight_h = Square.new('8h')]
    ]
  end

  # color 46 is light blue, color 40 is black
  def switch_color
    if @color == 46
      @color = 40
    else @color = 46
    end
  end

  def display
    p 'a  b  c  d  e  f  g  h'
    @grid.each do |row|
      row.each do |square|
        if square.piece.nil?
          print "\e[#{@color}m#{"   "}\e[0m"
        else
          print "\e[#{@color}m#{" #{square.piece.icon} "}\e[0m"
        end
        switch_color
      end
      puts "\n"
      switch_color
    end
  end
end
