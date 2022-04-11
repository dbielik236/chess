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

  def random_square
    row_choices = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    random_choice = []
    random_choice << row_choices.sample
    column_choices = ['1', '2', '3', '4', '5', '6', '7', '8']
    random_choice << column_choices.sample
    random_choice.join('')
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
  end

  def switch_current_player
    if @current_player == @computer || @current_player == nil
      @current_player = @human
    elsif @current_player == @human
      @current_player = @computer
    end
  end

  def move_pieces
    @board.move_piece(@starting_choice, @ending_choice)
  end

  def take_turns
    switch_current_player
    human_turn
    move_pieces
    @board.display
    switch_current_player
    computer_turn
    move_pieces
    @board.display
    display_computer_turn
  end

  def play_game
    @board.display
    establish_player
    establish_computer
    @board.display
    30.times do
      take_turns
    end
  end

  def empty_square?(location)
    @board.empty_square?([location])
  end
end
