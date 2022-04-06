# frozen_string_literal: true

require_relative 'square'
require_relative './pieces/pawn'
require_relative './pieces/rook'
require_relative './pieces/knight'
require_relative './pieces/bishop'
require_relative './pieces/queen'
require_relative './pieces/king'


# manages the grid, display, moving pieces, and check(mate)
class Board
  attr_accessor :grid, :starting_piece, :ending_piece

  def initialize
    # white pieces
    @white_pawn1 = Pawn.new('white', " \u2659 ")
    @white_pawn2 = Pawn.new('white', " \u2659 ")
    @white_pawn3 = Pawn.new('white', " \u2659 ")
    @white_pawn4 = Pawn.new('white', " \u2659 ")
    @white_pawn5 = Pawn.new('white', " \u2659 ")
    @white_pawn6 = Pawn.new('white', " \u2659 ")
    @white_pawn7 = Pawn.new('white', " \u2659 ")
    @white_pawn8 = Pawn.new('white', " \u2659 ")
    @white_rook1 = Rook.new('white', " \u2656 ")
    @white_rook2 = Rook.new('white', " \u2656 ")
    @white_knight1 = Knight.new('white', " \u2658")
    @white_knight2 = Knight.new('white', " \u2658")
    @white_bishop1 = Bishop.new('white', " \u2657 ")
    @white_bishop2 = Bishop.new('white', " \u2657 ")
    @white_queen = Queen.new('white', " \u2655 ")
    @white_king = King.new('white', " \u2654 ")

    # black pieces
    @black_pawn1 = Pawn.new('black', " \u265F ")
    @black_pawn2 = Pawn.new('black', " \u265F ")
    @black_pawn3 = Pawn.new('black', " \u265F ")
    @black_pawn4 = Pawn.new('black', " \u265F ")
    @black_pawn5 = Pawn.new('black', " \u265F ")
    @black_pawn6 = Pawn.new('black', " \u265F ")
    @black_pawn7 = Pawn.new('black', " \u265F ")
    @black_pawn8 = Pawn.new('black', " \u265F ")
    @black_rook1 = Rook.new('black', " \u265C ")
    @black_rook2 = Rook.new('black', " \u265C ")
    @black_knight1 = Knight.new('black', " \u265E")
    @black_knight2 = Knight.new('black', " \u265E")
    @black_bishop1 = Bishop.new('black', " \u265D ")
    @black_bishop2 = Bishop.new('black', " \u265D ")
    @black_queen = Queen.new('black', " \u2657 ")
    @black_king = King.new('black', " \u265A")

    # grid color
    @color = 47
    @starting_piece = nil
    @ending_piece = nil
    @grid = [
      [Square.new('8a', @white_rook), Square.new('8b', @black_rook), Square.new('8c'), Square.new('8d'), Square.new('8e'), Square.new('8f'), Square.new('8g'), Square.new('8h')], 
      [Square.new('7a', @white_pawn1), Square.new('8b'), Square.new('8c'), Square.new('8d'), Square.new('8e'), Square.new('8f'), Square.new('8g'), Square.new('8h')]
    ]
  end

  # color 49 is white, color 46 is teal (black squares)
  def switch_color
    if @color == 47
      @color = 46
    else @color = 47
    end
  end

  def display
    p 'a  b  c  d  e  f  g  h'
    @grid.each do |row|
      print @grid.index
      row.each do |square|
        if square.piece.nil?
          print "\e[#{@color}m#{"   "}\e[0m"
        else
          print "\e[#{@color}m#{"#{square.piece.icon}"}\e[0m"
        end
        switch_color
      end
      puts "\n"
      switch_color
    end
  end
end
