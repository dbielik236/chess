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

    #name needs to eliminate white space?
    name = gets.chomp
    player_color_prompt

    # again this needs white space eliminated
    color = gets.chomp
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

  def test
    @board.display
    @board.move_piece('d7', 'd6')
    @board.display
  end
end

game = Game.new
game.test

