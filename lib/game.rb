# frozen_string_literal: true

# controls the gameplay
class Game
  attr_accessor :board, :human, :computer, :current_player, :white_rook, :black_rook

  def initialize
    @board = Board.new
    @human = nil
    @computer = nil
    @current_player = nil
    @white_rook = Rook.new(white, '♖')
    @black_rook = Rook.new(black, '♜')
  end
end