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
      print 8 - index
      row.each do |square|
        if square.piece.nil?
          print "\e[#{@color}m#{"   "}\e[0m"
        else
          print "\e[#{@color}m#{"#{square.piece.icon}"}\e[0m"
        end
        switch_color
      end
      print 8 - index
      puts "\n"
      switch_color
    end
    puts '  a  b  c  d  e  f  g  h'
  end

  # private method?
  def convert_location(location)
    column_conversion = Hash[a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8]
    row = location[1].to_i
    column = column_conversion[:"#{location[0]}"]
    [row, column]
  end

  def correct_format?(location)
    row_possibilities = 'abcdefgh'
    column_possibilities = '12345678'
    !location[0].nil? &&
      !location[1].nil? &&
      row_possibilities.include?(location[0]) &&
      column_possibilities.include?(location[1]) &&
      location.length == 2
  end

  def on_the_board?(location)
    row, column = location
    row >= 1 && row <= 8 && column >= 1 && column <= 8
  end

  def legal_start?(start, color)
    starting_location = convert_location(start)
    retrieve_start_piece(starting_location)
    if @starting_piece == nil || @starting_piece.color != color
      false
    elsif @starting_piece.color == color
      true
    end
  end

  def legal_finish?(finish, color)
    ending_location = convert_location(finish)
    retrieve_end_piece(ending_location)
    @ending_piece.nil? || @ending_piece.color != color
  end

  def legal_move_for_piece?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    retrieve_start_piece(starting_location)
    retrieve_end_piece(ending_location)
    @starting_piece.legal_move?(starting_location, ending_location, @starting_piece, @ending_piece)
  end

  # private method?
  def retrieve_start(location)
    @grid.each do |row|
      row.each do |square|
        if square.location == location
          @starting_square = square
        else
          next
        end
      end
    end
  end

  def retrieve_start_piece(location)
    @grid.each do |row|
      row.each do |square|
        if square.location == location
          @starting_piece = square.piece
        else
          next
        end
      end
    end
  end

  # private method?
  def retrieve_end(location)
    @grid.each do |row|
      row.each do |square|
        if square.location == location
          @ending_square = square
          
        else
          next
        end
      end
    end
  end

  def retrieve_end_piece(location)
    @grid.each do |row|
      row.each do |square|
        if square.location == location
          @ending_piece = square.piece
        else
          next
        end
      end
    end
  end
  # used by board class
  def retrieve_class(location)
    actual_loc = convert_location(location)
    @grid.each do |row|
      row.each do |square|
        if square.location == actual_loc
          @starting_piece = square.piece
        else
          next
        end
      end
    end
    @starting_piece.class
  end

  def retrieve_piece(location)
    @grid.each do |row|
      row.each do |square|
        next unless square.location == location

        @current_piece = square.piece
      end
    end
    @current_piece
  end

  # can this be combined with others?
  def retrieve_location(type_of_piece, color)
    @grid.each do |row|
      row.each do |square|
        piece = square.piece
        if piece != nil &&
           piece.instance_of?(type_of_piece) &&
           piece.color == color
          @location = square.location
          
        else
          next
        end
      end
    end
    @location
  end

  def up_left_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    row, column = starting_location
    results = []
    row += 1
    column -= 1
    i = 1
    until i == 9 || ending_location == [row, column]
      retrieve_piece([row, column])
      results << @current_piece.nil?
      row += 1
      column -= 1
      i += 1
    end
    !results.include?(false)
  end

  def up_right_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    row, column = starting_location
    results = []
    row += 1
    column += 1
    i = 1
    until i == 9 || ending_location == [row, column]
      retrieve_piece([row, column])
      results << @current_piece.nil?
      row += 1
      column += 1
      i += 1
    end
    !results.include?(false)
  end

  def down_left_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    row, column = starting_location
    results = []
    row -= 1
    column -= 1
    i = 1
    until i == 9 || ending_location == [row, column]
      retrieve_piece([row, column])
      results << @current_piece.nil?
      row -= 1
      column -= 1
      i += 1
    end
    !results.include?(false)
  end

  def down_right_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    row, column = starting_location
    results = []
    row -= 1
    column += 1
    i = 1
    until i == 9 || ending_location == [row, column]
      retrieve_piece([row, column])
      results << @current_piece.nil?
      row -= 1
      column += 1
      i += 1
    end
    !results.include?(false)
  end

  def diagonal_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    start_row, start_column = starting_location
    end_row, end_column = ending_location
    if end_row > start_row && end_column < start_column
      up_left_clear?(start, finish)
    elsif end_row > start_row && end_column > start_column
      up_right_clear?(start, finish)
    elsif end_row < start_row && end_column < start_column
      down_left_clear?(start, finish)
    elsif end_row < start_row && end_column > start_column
      down_right_clear?(start, finish)
    end
  end

  def forward_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    row, column = starting_location
    results = []
    row += 1
    i = 1
    until i == 9 || ending_location == [row, column]
      retrieve_piece([row, column])
      results << @current_piece.nil?
      row += 1
      i += 1
    end
    !results.include?(false)
  end

  def backward_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    row, column = starting_location
    results = []
    row -= 1
    i = 1
    until i == 9 || ending_location == [row, column]
      retrieve_piece([row, column])
      results << @current_piece.nil?
      row -= 1
      i += 1
    end
    !results.include?(false)
  end

  def left_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    row, column = starting_location
    results = []
    column -= 1
    i = 1
    until i == 9 || ending_location == [row, column]
      retrieve_piece([row, column])
      results << @current_piece.nil?
      column -= 1
      i += 1
    end
    !results.include?(false)
  end

  def right_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    row, column = starting_location
    results = []
    column += 1
    i = 1
    until i == 9 || ending_location == [row, column]
      retrieve_piece([row, column])
      results << @current_piece.nil?
      column += 1
      i += 1
    end
    !results.include?(false)
  end

  def vertical_horizontal_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    start_row, start_column = starting_location
    end_row, end_column = ending_location
    if end_row > start_row
      forward_clear?(start, finish)
    elsif end_row < start_row
      backward_clear?(start, finish)
    elsif end_column > start_column
      right_clear?(start, finish)
    elsif end_column < start_column
      left_clear?(start, finish)
    end
  end

  def all_clear?(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    start_row, start_column = starting_location
    end_row, end_column = ending_location
    if end_row > start_row && end_column < start_column
      up_left_clear?(start, finish)
    elsif end_row > start_row && end_column > start_column
      up_right_clear?(start, finish)
    elsif end_row < start_row && end_column < start_column
      down_left_clear?(start, finish)
    elsif end_row < start_row && end_column > start_column
      down_right_clear?(start, finish)
    elsif end_row > start_row
      forward_clear?(start, finish)
    elsif end_row < start_row
      backward_clear?(start, finish)
    elsif end_column > start_column
      right_clear?(start, finish)
    elsif end_column < start_column
      left_clear?(start, finish)
    end
  end

  def pawn_path_clear?(start, color)
    starting_location = convert_location(start)
    row, column = starting_location
    if color == 'white'
      retrieve_piece([row + 1, column])
      @current_piece.nil?
    elsif color == 'black'
      retrieve_piece([row - 1, column])
      @current_piece.nil?
    end
  end

  def pawn_can_take_king?(start, finish, color)
    result = false
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    start_row, start_column = starting_location
    end_row, end_column = ending_location
    if color == 'black' && end_row == start_row - 1
      if end_column == start_column - 1 || end_column == start_column + 1
        result = true
      end
    elsif color == 'white' && end_row == start_row + 1
      if end_column == start_column - 1 || end_column == start_column + 1
        result = true
      end
    end
    result
  end

  def move_piece(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    retrieve_start(starting_location)
    retrieve_end(ending_location)
    @starting_square.piece.move_count += 1
    if @ending_square.piece == nil
      @reserve = nil
    else
      @reserve = @ending_square.piece
    end
    @ending_square.piece = @starting_square.piece
    @starting_square.piece = nil
  end

  def move_piece_back(start, finish)
    starting_location = convert_location(start)
    ending_location = convert_location(finish)
    retrieve_start(starting_location)
    retrieve_end(ending_location)
    @ending_square.piece.move_count -= 1
    @starting_square.piece = @ending_square.piece
    @ending_square.piece = @reserve
  end
end
