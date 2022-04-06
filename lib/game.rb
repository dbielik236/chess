# frozen_string_literal: true

require_relative 'board'

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
    

  def test
    @board.convert_location('f2')
  end
end

game = Game.new
conversion = game.test

p conversion
