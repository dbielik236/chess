# frozen_string_literal: true

require_relative 'board'
require_relative 'prompts'

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
    ending_square_prompt
    ending_choice = gets.chomp.strip
    until @board.legal_move?(starting_choice, ending_choice, @current_player.color)
      starting_piece_prompt
      starting_choice = gets.chomp.strip
      ending_square_prompt
      ending_choice = gets.chomp.strip
    end
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
    human_turn
    @board.move_piece
    @board.replace_piece
    switch_current_player
    computer_turn
  end

  def play_game
    take_turns
  end
end

game = Game.new
game.play_game

