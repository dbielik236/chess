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
    8.times do
      columns.each do |column|
        every_location << rows[num] + column
      end
      num += 1
    end
    every_location
  end

  def revert_location(location)
    row_conversion = Hash[1 => 'a', 2 => 'b', 3 => 'c', 4 => 'd', 5 => 'e', 6 => 'f', 7 => 'g', 8 => 'h']
    row, column = location
    row = row_conversion[row]
    "#{row}#{column}"
  end



  def in_check?(ending_location)
    results = []
    list = create_list
    list.each do |starting_location|
      if @board.legal_start?(starting_location, @current_player.color) &&
         @board.legal_finish?(ending_location, @current_player.color) &&
         if @board.retrieve_class(starting_location) == Bishop
           @board.diagonal_clear?(starting_location, ending_location)
         elsif @board.retrieve_class(starting_location) == Rook
           @board.vertical_horizontal_clear?(starting_location, ending_location)
         elsif @board.retrieve_class(starting_location) == Queen
           @board.all_clear?(starting_location, ending_location)
         end
        results << true
      else
        results << false
      end
    end
    !results.include?(false)
  end

  def piece_is_a_king?(location)
    retrieve_class(location) == King
  end

  def king_is_in_check?
    if @current_player == @human
      color = @human.color
    else
      color = @computer.color
    end
    location = @board.retrieve_location(King, color)
    chess_notation_location = revert_location(location)
    @check = in_check?(chess_notation_location)
  end

  def check_mate?
    if @current_player == @human
      color = @human.color
    else
      color = @computer.color
    end
    location = @board.retrieve_location(King, color)
    row, column = location
    results = []
    possible_moves = [
      [row, column],
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
      if @board.on_the_board?(loc)
        in_check?(revert_location(loc))
        results << @check
      end
    end
    !results.include?(false)
  end

  # I think this is ready too
  def space_will_put_king_in_check?(location)
    in_check?(location)
  end

  def computer_turn
    if @check == true
      @starting_choice = revert_location(@board.retrieve_location(King))
    else
      @starting_choice = random_square
      # checks to makes sure that the player has a piece there
      until @board.legal_start?(@starting_choice, @current_player.color)
        @starting_choice = random_square
      end
    end
    @ending_choice = random_square
    unless @board.legal_finish?(@ending_choice, @current_player.color) && @board.legal_move_for_piece?(@starting_choice, @ending_choice)
      computer_turn
    end
    # checks that the finish square is available
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
    if space_will_put_king_in_check?(@ending_choice)
      computer_turn
    end
  end

  def human_turn
    if @check == true
      king_is_in_check_prompt
      @starting_choice = revert_location(@board.retrieve_location(King))
    else
      starting_piece_prompt
      @starting_choice = gets.chomp.strip
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
    # until correct legal move for piece...?
    until @ending_choice == 'p' || @board.legal_move_for_piece?(@starting_choice, @ending_choice)
      illegal_move_for_piece_prompt
      @ending_choice = gets.chomp.strip
    end
    # if piece is a bishop check diagonal lines for clear
    if @board.retrieve_class(@starting_choice) == Bishop
      until @ending_choice == 'p' || @board.diagonal_clear?(@starting_choice, @ending_choice)
        path_not_clear_prompt
        @ending_choice = gets.chomp.strip
      end
    end
    if @board.retrieve_class(@starting_choice) == Rook
      until @ending_choice == 'p' || @board.vertical_horizontal_clear?(@starting_choice, @ending_choice)
        path_not_clear_prompt
        @ending_choice = gets.chomp.strip
      end
    end
    if @board.retrieve_class(@starting_choice) == Queen
      until @ending_choice == 'p' || @board.all_clear?(@starting_choice, @ending_choice)
        path_not_clear_prompt
        @ending_choice = gets.chomp.strip
      end
    end
    if @ending_choice == 'p'
      human_turn
    end
    if space_will_put_king_in_check?(@ending_choice)
      space_will_put_king_in_check_prompt
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

  def move_pieces
    @board.move_piece(@starting_choice, @ending_choice)
  end

  def one_turn
    if @current_player == @human
      human_turn
    else
      computer_turn
    end
    move_pieces
    @board.display
    if @current_player == @computer
      display_computer_turn
    end
    switch_current_player
  end

  def play_game
    @board.display
    establish_player
    establish_computer
    establish_current_player
    @board.display
    one_turn
    until check_mate?
      if @check == true
        king_is_in_check_prompt
      else
        puts "King is not check.."
      end
      one_turn
    end
  end
end
