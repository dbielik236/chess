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
    @white_knight1 = Knight.new('white', " \u2658 ")
    @white_knight2 = Knight.new('white', " \u2658 ")
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
    @black_knight1 = Knight.new('black', " \u265E ")
    @black_knight2 = Knight.new('black', " \u265E ")
    @black_bishop1 = Bishop.new('black', " \u265D ")
    @black_bishop2 = Bishop.new('black', " \u265D ")
    @black_queen = Queen.new('black', " \u265B ")
    @black_king = King.new('black', " \u265A ")

    # grid color
    @color = 47
    @starting_piece = nil
    @ending_piece = nil
    @grid = [
      [Square.new([8, 1], @black_rook1), Square.new([8, 2], @black_knight1), Square.new([8, 3], @black_bishop1), Square.new([8, 4], @black_queen), Square.new([8, 5], @black_king), Square.new([8, 6], @black_bishop2), Square.new([8, 7], @black_knight2), Square.new([8, 8], @black_rook2)], 
      [Square.new([7, 1], @black_pawn1), Square.new([7, 2], @black_pawn2), Square.new([7, 3], @black_pawn3), Square.new([7, 4], @black_pawn4), Square.new([7, 5], @black_pawn5), Square.new([7, 6], @black_pawn6), Square.new([7, 7], @black_pawn7), Square.new([7, 8], @black_pawn8)], 
      [Square.new([6, 1]), Square.new([6, 2]), Square.new([6, 3]), Square.new([6, 4]), Square.new([6, 5]), Square.new([6, 6]), Square.new([6, 7]), Square.new([6, 8])], 
      [Square.new([5, 1]), Square.new([5, 2]), Square.new([5, 3]), Square.new([5, 4]), Square.new([5, 5]), Square.new([5, 6]), Square.new([5, 7]), Square.new([5, 8])],
      [Square.new([4, 1]), Square.new([4, 2]), Square.new([4, 3]), Square.new([4, 4]), Square.new([4, 5]), Square.new([4, 6]), Square.new([4, 7]), Square.new([4, 8])],
      [Square.new([3, 1]), Square.new([3, 2]), Square.new([3, 3]), Square.new([3, 4]), Square.new([3, 5]), Square.new([3, 6]), Square.new([3, 7]), Square.new([3, 8])],
      [Square.new([2, 1], @white_pawn1), Square.new([2, 2], @white_pawn2), Square.new([2, 3], @white_pawn3), Square.new([2, 4], @white_pawn4), Square.new([2, 5], @white_pawn5), Square.new([2, 6], @white_pawn6), Square.new([2, 7], @white_pawn7), Square.new([2, 8], @white_pawn8)], 
      [Square.new([1, 1], @white_rook1), Square.new([1, 2], @white_knight2), Square.new([1, 3], @white_bishop2), Square.new([1, 4], @white_queen), Square.new([1, 5], @white_king), Square.new([1, 6], @white_bishop2), Square.new([1, 7], @white_knight2), Square.new([1, 8], @white_rook2)]
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
    puts '  a  b  c  d  e  f  g  h'
    @grid.each_with_index do |row, index|
      print index + 1
      row.each do |square|
        if square.piece.nil?
          print "\e[#{@color}m#{"   "}\e[0m"
        else
          print "\e[#{@color}m#{"#{square.piece.icon}"}\e[0m"
        end
        switch_color
      end
      print index + 1
      puts "\n"
      switch_color
    end
    puts '  a  b  c  d  e  f  g  h'
  end

  def convert_location(location)
    column_conversion = Hash[a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8]
    row = location[1].to_i
    column = column_conversion[:"#{location[0]}"]
    [row, column]
  end

  def in_bounds?(location)
    row, column = location
    row >= 0 && row <= 8 && column >= 0 && column <= 8
  end

  def retrieve_start(location)
    @grid.each do |row|
      row.each do |square|
        if square.location == location
          @starting_square = square
          @starting_piece = square.piece
        else
          next
        end
      end
    end
  end

  def retrieve_end(location)
    @grid.each do |row|
      row.each do |square|
        if square.location == location
          @ending_square = square
          @ending_piece = square.piece
        else
          next
        end
      end
    end
  end

  def move_piece(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    retrieve_start(starting_location)
    retrieve_end(ending_location)
    @ending_square.piece = @starting_square.piece
    @starting_square.piece = nil
  end


end
