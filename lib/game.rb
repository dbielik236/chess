# frozen_string_literal: true

require_relative 'board'
require_relative 'prompts'
require_relative 'human'
require_relative 'computer'
require_relative './pieces/pawn'
require_relative './pieces/rook'
require_relative './pieces/knight'
require_relative './pieces/bishop'
require_relative './pieces/queen'
require_relative './pieces/king'
require_relative 'save_load_game'

# controls the gameplay
class Game
  attr_accessor :board, :human, :computer, :current_player, :starting_choice, :ending_choice

  include Display
  include SaveLoad

  def initialize
    @board = Board.new
    @human = nil
    @computer = nil
    @current_player = nil
    @check = false
    @num = 0
    @castle = 0
    @starting_choice = nil
    @ending_choice = nil
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
      if @board.retrieve_class(location) == Bishop
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
      # ???
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
           @board.legal_finish?(ending_location, @current_player.color) &&
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
                 @board.legal_finish?(revert_location([bishop_row, bishop_column]), @current_player.color) &&
                 @board.diagonal_clear?(starting_location, revert_location([bishop_row, bishop_column]))
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
                 @board.legal_finish?(revert_location([bishop_row, bishop_column]), @current_player.color) &&
                 @board.diagonal_clear?(starting_location, revert_location([bishop_row, bishop_column]))
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
                 @board.legal_finish?(revert_location([bishop_row, bishop_column]), @current_player.color) &&
                 @board.diagonal_clear?(starting_location, revert_location([bishop_row, bishop_column]))
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
                 @board.legal_finish?(revert_location([bishop_row, bishop_column]), @current_player.color) &&
                 @board.diagonal_clear?(starting_location, revert_location([bishop_row, bishop_column]))
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
                 @board.legal_finish?(revert_location([rook_row, rook_column]), @current_player.color) &&
                 @board.vertical_horizontal_clear?(starting_location, revert_location([rook_row, rook_column]))
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
                 @board.legal_finish?(revert_location([rook_row, rook_column]), @current_player.color) &&
                 @board.vertical_horizontal_clear?(starting_location, revert_location([rook_row, rook_column]))
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
                 @board.legal_finish?(revert_location([rook_row, rook_column]), @current_player.color) &&
                 @board.vertical_horizontal_clear?(starting_location, revert_location([rook_row, rook_column]))
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
                 @board.legal_finish?(revert_location([rook_row, rook_column]), @current_player.color) &&
                 @board.vertical_horizontal_clear?(starting_location, revert_location([rook_row, rook_column]))
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
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color) &&
                 @board.all_clear?(starting_location, revert_location([queen_row, queen_column]))
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
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color) &&
                 @board.all_clear?(starting_location, revert_location([queen_row, queen_column]))
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
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color) &&
                 @board.all_clear?(starting_location, revert_location([queen_row, queen_column]))
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
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color) &&
                 @board.all_clear?(starting_location, revert_location([queen_row, queen_column]))
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
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color) &&
                 @board.all_clear?(starting_location, revert_location([queen_row, queen_column]))
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
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color) &&
                 @board.all_clear?(starting_location, revert_location([queen_row, queen_column]))
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
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color) &&
                 @board.all_clear?(starting_location, revert_location([queen_row, queen_column]))
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
                 @board.legal_finish?(revert_location([queen_row, queen_column]), @current_player.color) &&
                 @board.all_clear?(starting_location, revert_location([queen_row, queen_column]))
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
    choice = false
    @starting_choice = random_square
    # checks to makes sure that the player has a piece there
    until @board.legal_start?(@starting_choice, @current_player.color)
      @starting_choice = random_square
    end
    until choice == true
      @ending_choice = random_square
      starting_choice_class = @board.retrieve_class(@starting_choice)
      if starting_choice_class == Pawn
        choice = @board.pawn_path_clear?(@starting_choice, @ending_choice, @current_player.color)
      end
      if starting_choice_class == Bishop
        choice = @board.diagonal_clear?(@starting_choice, @ending_choice)
      end
      if starting_choice_class == Rook
        choice = @board.vertical_horizontal_clear?(@starting_choice, @ending_choice)
      end
      if starting_choice_class == Queen
        choice = @board.all_clear?(@starting_choice, @ending_choice)
      end
      if @board.legal_finish?(@ending_choice, @current_player.color) && 
         @board.legal_move_for_piece?(@starting_choice, @ending_choice)
        choice = true
      else
        choice = false
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
    elsif @starting_choice == 's'
      save_game(self)
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
    if @board.retrieve_class(@starting_choice) == Pawn && @starting_choice[1] == @ending_choice[1]
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

  # is this being used anywhere?
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
        if @board.retrieve_piece(@board.convert_location('g1')).nil? &&
           @board.retrieve_piece(@board.convert_location('f1')).nil? &&
           in_check?('g1') == false &&
           in_check?('f1') == false
          move_pieces('h1', 'f1')
          move_pieces('e1', 'g1')
          @castle = 1
        else
          cannot_castle_prompt
          return
        end
      end
      if rook_location == 'a8'
        if @board.retrieve_piece(@board.convert_location('b8')).nil? &&
           @board.retrieve_piece(@board.convert_location('c8')).nil? &&
           @board.retrieve_piece(@board.convert_location('d8')).nil? &&
           in_check?('b8') == false &&
           in_check?('c8') == false &&
           in_check?('d8') == false
          move_pieces('a8', 'd8')
          move_pieces('e8', 'c8')
          @castle = 1
        else
          cannot_castle_prompt
          return
        end
      end
      if rook_location == 'h8'
        if @board.retrieve_piece(@board.convert_location('g8')).nil? &&
           @board.retrieve_piece(@board.convert_location('f8')).nil? &&
           in_check?('g8') == false &&
           in_check?('f8') == false
          move_pieces('h8', 'f8')
          move_pieces('e8', 'g8')
          @castle = 1
        else
          cannot_castle_prompt
        end
      end
    else
      cannot_castle_prompt
    end
  end

  def last_row(color)
    if color == 'white'
      [[8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [8, 6], [8, 7], [8, 8]]
    elsif color == 'black'
      [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8]]
    end
  end

  def promote_piece(letter)
    row = last_row(@current_player.color)
    row.each do |loc|
      if @board.retrieve_class(revert_location(loc)) == Pawn
        square = @board.retrieve_start(loc)
        if @current_player.color == 'white'
          case letter
          when 'q'
            square.piece = Queen.new(@current_player.color, " \u2655 ")
          when 'b'
            square.piece = Bishop.new(@current_player.color, " \u2657 ")
          when 'k'
            square.piece = Knight.new(@current_player.color, " \u2658 ")
          when 'r'
            square.piece = Rook.new(@current_player.color, " \u2656 ")
          end
        elsif @current_player.color == 'black'
          case letter
          when 'q'
            square.piece = Queen.new(@current_player.color, " \u265B ")
          when 'b'
            square.piece = Bishop.new(@current_player.color, " \u265D ")
          when 'k'
            square.piece = Knight.new(@current_player.color, " \u265E ")
          when 'r'
            square.piece = Rook.new(@current_player.color, " \u265C ")
          end
        end
      end
    end
  end

  def pawn_promotion_human
    row = last_row(@current_player.color)
    row.each do |loc|
      if @board.retrieve_class(revert_location(loc)) == Pawn
        pawn_promote_prompt
        piece = gets.chomp
        until piece == 'q' || piece == 'b' || piece == 'k' || piece == 'r'
          incorrect_piece_prompt
          piece = gets.chomp
        end
        promote_piece(piece)
        @board.display
        display_piece_promoted
      end
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
      if king_is_in_check?
        computer_king_is_in_check_display
      end
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
    switch_current_player
  end

  def establish_game
    @board.display
    establish_player
    establish_computer
    establish_current_player
    # first turn to start the game
    first_turn
  end

  def play_game
    until check_mate?
      @board.display
      one_turn
      if @current_player == @computer
        display_computer_making_turn
        sleep(0.5)
        print "."
        sleep(0.5)
        print "."
        sleep(0.5)
        print ".\n"
        sleep(0.5)
      end
      if @current_player == @computer
        display_computer_turn
      end
      if @current_player == @human
        pawn_promotion_human
      elsif @current_player == @computer
        promote_piece('q')
      end
      switch_current_player
    end
    if check_mate?
      @board.display
    end
  end
end
