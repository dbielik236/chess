# frozen_string_literal: true

require_relative 'board'

# controls the gameplay
class Game
  attr_accessor :board, :human, :computer, :current_player

  def initialize
    @board = Board.new
    @human = nil
    @computer = nil
    @current_player = nil
  end

  def test
    @board.display
  end
end

game = Game.new
game.test
