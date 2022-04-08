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

  def computer_turn
    # makes a move
  end

  def human_turn
    starting_piece_prompt
    starting_choice = gets.chomp.strip
    # checks to see if the player has used the correct format
    until @board.correct_format?(starting_choice)
      incorrect_format_prompt
      starting_choice = gets.chomp.strip
    end
    # checks to makes sure that the player has a piece there
    until @board.legal_start?(starting_choice, @current_player.color)
      illegal_location_prompt
      starting_choice = gets.chomp.strip
    end
    ending_square_prompt
    # checks to see if the player used the right format
    ending_choice = gets.chomp.strip
    until @board.correct_format?(ending_choice)
      incorrect_format_prompt
      ending_choice = gets.chomp.strip
    end
    # checks that the finish square is available
    until @board.legal_finish?(ending_choice, @current_player.color)
      illegal_location_prompt
      ending_choice = gets.chomp.strip
    end
    # until correct legal move for piece...?
    until @board.legal_move_for_piece?(starting_choice, ending_choice)
      illegal_location_prompt
      ending_choice = gets.chomp.strip
    end
    @board.move_piece(starting_choice, ending_choice)
  end

  def switch_current_player
    if @current_player = @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end

  def take_turns
    @board.display
    @current_player = @human
    human_turn
    switch_current_player
    @board.display
  end

  def play_game
    @board.display
    establish_player
    establish_computer
    take_turns
  end
end

