# frozen_string_literal: true

require_relative 'board'
require_relative 'prompts'
require_relative 'human'
require_relative 'computer'

# controls the gameplay
class Game
  attr_accessor :board, :human, :computer, :current_player

  include Display

  def initialize
    @board = Board.new
    @human = nil
    @computer = nil
    @current_player = nil
    @check = false
    @num = 0
    @castle = 0
  end

  def establish_player
    player_name_prompt
    name = gets.chomp.strip
    player_color_prompt
    color = gets.chomp.strip
    until color == 'w' or color == 'b'
      color_error_prompt
      color = gets.chomp
    end
    if color == 'w'
      @human = Human.new(name, 'white')
    else
      @human = Human.new(name, 'black')
    end
  end

  def establish_computer
    if @human.color == 'white'
      @computer = Computer.new('black')
    else
      @computer = Computer.new('white')
    end
  end

  def establish_current_player
    if @human.color == 'white'
      @current_player = @human
    else
      @current_player = @computer
    end
  end

  def random_square
    row_choices = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    random_choice = []
    random_choice << row_choices.sample
    column_choices = ['1', '2', '3', '4', '5', '6', '7', '8']
    random_choice << column_choices.sample
    random_choice.join('')
  end

  def create_list
    rows = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    columns = ['1', '2', '3', '4', '5', '6', '7', '8']
    every_location = []
    num = 0
    until num == 8
      columns.each do |column|
        every_location << "#{rows[num]}#{column}"
      end
      num += 1
    end
    every_location
  end

  def revert_location(location)
    column_conversion = Hash[1 => 'a', 2 => 'b', 3 => 'c', 4 => 'd', 5 => 'e', 6 => 'f', 7 => 'g', 8 => 'h']
    row, column = location
    column = column_conversion[column]
    "#{column}#{row}"
  end

  def in_check?(ending_location)
    if @current_player == @human && @human.color == 'white'
      color = 'black'
    elsif current_player == @human && @human.color == 'black'
      color = 'white'
    elsif @current_player == @computer && @computer.color == 'white'
      color = 'black'
    elsif @current_player == @computer && @computer.color == 'black'
      color = 'white'
    end
    @results = []
    list = create_list
    list.each do |starting_location|
      if @board.legal_start?(starting_location, color) &&
         @board.legal_move_for_piece?(starting_location, ending_location)
        @results << starting_location
      end
    end
    bishops_rooks_queens = []
    @results.each do |location|
      if @board.retrieve_class(location) == Pawn
        if @board.pawn_can_take_king?(location, ending_location, color) == false
          bishops_rooks_queens << location
        end
      elsif @board.retrieve_class(location) == Bishop
        if @board.diagonal_clear?(location, ending_location) == false
          bishops_rooks_queens << location
        end
      elsif @board.retrieve_class(location) == Rook
        if @board.vertical_horizontal_clear?(location, ending_location) == false
          bishops_rooks_queens << location
        end
      elsif @board.retrieve_class(location) == Queen
        if @board.all_clear?(location, ending_location) == false
          bishops_rooks_queens << location
        end
      end
    end
    bishops_rooks_queens.each do |element|
      @results.delete(element)
    end
    !@results[0].nil?
  end

  # is this being used?
  def piece_is_a_king?(location)
    @board.retrieve_class(location) == King
  end

  def king_is_in_check?
    if @current_player == @human
      color = @human.color
    else
      color = @computer.color
    end
    location = @board.retrieve_location(King, color)
    chess_notation_location = revert_location(location)
    in_check?(chess_notation_location)
  end

  def king_has_no_moves?
    if @current_player == @human
      color = @human.color
    else
      color = @computer.color
    end
    location = @board.retrieve_location(King, color)
    row, column = location
    results = []
    possible_moves = [
      [row + 1, column],
      [row, column + 1],
      [row - 1, column],
      [row, column - 1],
      [row + 1, column + 1],
      [row - 1, column - 1],
      [row + 1, column - 1],
      [row - 1, column + 1]
    ]
    possible_moves.each do |loc|
      if @board.on_the_board?(loc) && @board.legal_finish?(revert_location(loc), color)
        results << in_check?(revert_location(loc))
      end
    end
    results << in_check?(revert_location(location))
    !results.include?(false) && results[0] != nil
  end

  def pieces_cannot_be_taken_out?
    pieces = []
    list = create_list
    list.each do |starting_location|
      @results.each do |ending_location|
        if @board.legal_start?(starting_location, @current_player.color) &&
           @board.legal_move_for_piece?(starting_location, ending_location)
          if @board.retrieve_class(ending_location) == Bishop && @board.diagonal_clear?(starting_location, ending_location) == false
            pieces << starting_location
          end
          if @board.retrieve_class(ending_location) == Rook && @board.vertical_horizontal_clear?(starting_location, ending_location) == false
            pieces << starting_location
          end
          if @board.retrieve_class(ending_location) == Queen && @board.all_clear?(starting_location, ending_location) == false
            pieces << starting_location
          end
        end
      end
    end
    pieces[0].nil?
  end

  def piece_cannot_be_moved_into_the_path_of_bishops?
    possible_moves = []
    list = create_list
    king_location = @board.retrieve_location(King, @current_player.color)
    king_row, king_column = king_location
    @results.each do |location|
      if @board.retrieve_class(location) == Bishop
        bishop_location = @board.convert_location(location)
        bishop_row, bishop_column = bishop_location
        if king_row > bishop_row && king_column > bishop_column 
          until king_location == [bishop_row, bishop_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([bishop_row, bishop_column])) &&
                 @board.legal_finish?(revert_location([bishop_row, bishop_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            bishop_row += 1
            bishop_column += 1
          end
        end
        if king_row > bishop_row && king_column < bishop_column
          until king_location == [bishop_row, bishop_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([bishop_row, bishop_column])) &&
                 @board.legal_finish?(revert_location([bishop_row, bishop_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            bishop_row += 1
            bishop_column -= 1
          end
        end
        if king_row < bishop_row && king_column > bishop_column
          until king_location == [bishop_row, bishop_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([bishop_row, bishop_column])) &&
                 @board.legal_finish?(revert_location([bishop_row, bishop_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            bishop_row -= 1
            bishop_column += 1
          end
        end
        if king_row < bishop_row && king_column < bishop_column
          until king_location == [bishop_row, bishop_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([bishop_row, bishop_column])) &&
                 @board.legal_finish?(revert_location([bishop_row, bishop_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            bishop_row -= 1
            bishop_column -= 1
          end
        end
      end
    end
    possible_moves[0].nil?
  end

  def piece_cannot_be_moved_into_the_path_of_rooks?
    possible_moves = []
    list = create_list
    king_location = @board.retrieve_location(King, @current_player.color)
    king_row, king_column = king_location
    @results.each do |location|
      if @board.retrieve_class(location) == Rook
        rook_location = @board.convert_location(location)
        rook_row, rook_column = rook_location
        if king_row > rook_row
          until king_location == [rook_row, rook_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([rook_row, rook_column])) &&
                 @board.legal_finish?(revert_location([rook_row, rook_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            rook_row += 1
          end
        end
        if king_row < rook_row
          until king_location == [rook_row, rook_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([rook_row, rook_column])) &&
                 @board.legal_finish?(revert_location([rook_row, rook_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            rook_row -= 1
          end
        end
        if king_column > rook_column
          until king_location == [rook_row, rook_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([rook_row, rook_column])) &&
                 @board.legal_finish?(revert_location([rook_row, rook_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            rook_column += 1
          end
        end
        if king_column < rook_column
          until king_location == [rook_row, rook_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([rook_row, rook_column])) &&
                 @board.legal_finish?(revert_location([rook_row, rook_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            rook_column -= 1
          end
        end
      end
    end
    possible_moves[0].nil?
  end

  def piece_cannot_move_into_the_path_of_queens?
    possible_moves = []
    list = create_list
    king_location = @board.retrieve_location(King, @current_player.color)
    king_row, king_column = king_location
    @results.each do |location|
      if @board.retrieve_class(location) == Queen
        queen_location = @board.convert_location(location)
        queen_row, queen_column =queen_location
        if king_row > queen_row
          until king_location == [queen_row, queen_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([queen_row, queen_column])) &&
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            queen_row += 1
          end
        end
        if king_row < queen_row
          until king_location == [queen_row, queen_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([queen_row, queen_column])) &&
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            queen_row -= 1
          end
        end
        if king_column > queen_column
          until king_location == [queen_row, queen_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([queen_row, queen_column])) &&
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            queen_column += 1
          end
        end
        if king_column < queen_column
          until king_location == [queen_row, queen_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([queen_row, queen_column])) &&
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            queen_column -= 1
          end
        end
        if king_row > queen_row && king_column > queen_column
          until king_location == [queen_row, queen_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([queen_row, queen_column])) &&
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            queen_row += 1
            queen_column += 1
          end
        end
        if king_row > queen_row && king_column < queen_column
          until king_location == [queen_row, queen_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([queen_row, queen_column])) &&
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            queen_row += 1
            queen_column -= 1
          end
        end
        if king_row < queen_row && king_column > queen_column
          until king_location == [queen_row, bqueen_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([queen_row, queen_column])) &&
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            queen_row -= 1
            queen_column += 1
          end
        end
        if king_row < queen_row && king_column < queen_column
          until king_location == [queen_row, queen_column]
            list.each do |starting_location|
              if @board.legal_start?(starting_location, @current_player.color) &&
                 @board.legal_move_for_piece?(starting_location, revert_location([queen_row, queen_column])) &&
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color)
                possible_moves << starting_location
              end
            end
            queen_row -= 1
            queen_column -= 1
          end
        end
      end
    end
    possible_moves[0].nil?
  end

  def check_mate?
    king_has_no_moves? &&
      pieces_cannot_be_taken_out? &&
      piece_cannot_be_moved_into_the_path_of_bishops? &&
      piece_cannot_be_moved_into_the_path_of_rooks?
  end

  # is this being used anywhere?
  def will_put_king_in_check?(location)
    in_check?(location)
  end

  def computer_turn
    @starting_choice = random_square
    # checks to makes sure that the player has a piece there
    until @board.legal_start?(@starting_choice, @current_player.color)
      @starting_choice = random_square
    end
    @ending_choice = random_square
    unless @board.legal_finish?(@ending_choice, @current_player.color) && @board.legal_move_for_piece?(@starting_choice, @ending_choice)
      computer_turn
    end
    # checks that the finish square is available
    if @board.retrieve_class(@starting_choice) == Pawn
      unless @board.pawn_path_clear?(@starting_choice, @current_player.color)
        computer_turn
      end
    end
    if @board.retrieve_class(@starting_choice) == Bishop
      unless @board.diagonal_clear?(@starting_choice, @ending_choice)
        computer_turn
      end
    end
    if @board.retrieve_class(@starting_choice) == Rook
      unless @board.vertical_horizontal_clear?(@starting_choice, @ending_choice)
        computer_turn
      end
    end
    if @board.retrieve_class(@starting_choice) == Queen
      unless @board.all_clear?(@starting_choice, @ending_choice)
        computer_turn
      end
    end
  end

  def human_turn
    @castle = 0
    starting_piece_prompt
    @starting_choice = gets.chomp
    if @starting_choice == 'c'
      which_rook_to_castle_prompt
      rook = gets.chomp
      castle(rook)
    end
    return if @castle == 1

    # checks to see if the player has used the correct format
    until @board.correct_format?(@starting_choice)
      incorrect_format_prompt
      @starting_choice = gets.chomp.strip
    end
    # checks to makes sure that the player has a piece there
    until @board.legal_start?(@starting_choice, @current_player.color)
      illegal_starting_location_prompt
      @starting_choice = gets.chomp.strip
    end
    ending_square_prompt
    # checks to see if the player used the right format
    @ending_choice = gets.chomp.strip
    until @board.correct_format?(@ending_choice)
      incorrect_format_prompt
      @ending_choice = gets.chomp.strip
    end
    # checks that the finish square is available
    until @ending_choice == 'p' || @board.legal_finish?(@ending_choice, @current_player.color)
      illegal_ending_location_prompt
      @ending_choice = gets.chomp.strip
    end
    # checks that it is a legal move for the piece
    until @ending_choice == 'p' || @board.legal_move_for_piece?(@starting_choice, @ending_choice)
      illegal_move_for_piece_prompt
      @ending_choice = gets.chomp.strip
    end
    # checks to see if the pawn path is clear
    if @board.retrieve_class(@starting_choice) == Pawn
      until @ending_choice == 'p' || @board.pawn_path_clear?(@starting_choice, @current_player.color)
        path_not_clear_prompt
        @ending_choice = gets.chomp.strip
      end
    end
    # checks that the diagonal lines are clear if a piece is a bishop
    if @board.retrieve_class(@starting_choice) == Bishop
      until @ending_choice == 'p' || @board.diagonal_clear?(@starting_choice, @ending_choice)
        path_not_clear_prompt
        @ending_choice = gets.chomp.strip
      end
    end
    # checks that the vertical/horizontal lines are clear if a piece is a rook
    if @board.retrieve_class(@starting_choice) == Rook
      until @ending_choice == 'p' || @board.vertical_horizontal_clear?(@starting_choice, @ending_choice)
        path_not_clear_prompt
        @ending_choice = gets.chomp.strip
      end
    end
    # checks that the all lines are clear if a piece is a queen
    if @board.retrieve_class(@starting_choice) == Queen
      until @ending_choice == 'p' || @board.all_clear?(@starting_choice, @ending_choice)
        path_not_clear_prompt
        @ending_choice = gets.chomp.strip
      end
    end
    if @ending_choice == 'p'
      human_turn
    end
  end

  def empty_square?(location)
    @board.empty_square?([location])
  end

  def switch_current_player
    if @current_player == @computer
      @current_player = @human
    elsif @current_player == @human
      @current_player = @computer
    end
  end

  def castle(rook_location)
    king_location = @board.retrieve_location(King, @current_player.color)
    king = @board.retrieve_piece(king_location)
    rook = @board.retrieve_piece(@board.convert_location(rook_location))
    if king.move_count.zero? && rook.move_count.zero? && king_is_in_check? == false
      if rook_location == 'a1'
        if @board.retrieve_piece(@board.convert_location('b1')).nil? &&
           @board.retrieve_piece(@board.convert_location('c1')).nil? &&
           @board.retrieve_piece(@board.convert_location('d1')).nil? &&
           in_check?('b1') == false &&
           in_check?('c1') == false &&
           in_check?('d1') == false
          move_pieces('a1', 'd1')
          move_pieces('e1', 'c1')
          @castle = 1
        else
          
          cannot_castle_prompt
          return
        end
      end
      if rook_location == 'h1'
      # if b1, c1, and d1 are nil and not in check
      # move the king to c1 and the rook to d1
      end
      if rook_location == 'a8'
      # if b1, c1, and d1 are nil and not in check
      # move the king to c1 and the rook to d1
      end
      if rook_location == 'h8'
      # if b1, c1, and d1 are nil and not in check
      # move the king to c1 and the rook to d1
      end
    else
      cannot_castle_prompt
      return
    end
  end

  def move_pieces(start = @starting_choice, finish = @ending_choice)
    @board.move_piece(start, finish)
  end

  def move_pieces_back
    @board.move_piece_back(@starting_choice, @ending_choice)
  end

  def one_turn
    if @current_player == @human
      if king_is_in_check?
        king_is_in_check_prompt
      end
      human_turn
      # temporarily move the pieces to check
      unless @castle == 1
        move_pieces
      end
      until king_is_in_check? == false || check_mate?
        # move the pieces back
        move_pieces_back
        move_will_put_king_in_check_prompt
        human_turn
        move_pieces
      end
    else
      computer_turn
      move_pieces
      until king_is_in_check? == false || check_mate?
        move_pieces_back
        computer_turn
        move_pieces
      end
    end
  end

  def first_turn
    if @current_player == @human
      human_turn
    else
      computer_turn
    end
    if @current_player == @computer
      display_computer_turn
    end
    unless @castle == 1
      move_pieces
    end
    @board.display
    switch_current_player
  end

  def play_game
    @board.display
    establish_player
    establish_computer
    establish_current_player
    # first turn to start the game
    first_turn
    until check_mate?
      one_turn
      if @current_player == @computer
        display_computer_making_turn
        sleep(0.25)
        print "."
        sleep(0.25)
        print "."
        sleep(0.25)
        print ".\n"
        sleep(0.25)
      end
      @board.display
      if @current_player == @computer
        display_computer_turn
      end
      switch_current_player
    end
  end
end
