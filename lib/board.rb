# frozen_string_literal: true

require_relative "square"

# manages the grid, display, moving pieces, and check(mate)
class Board
  attr_accessor :grid, :starting_piece, :ending_piece

  def initialize
    @starting_piece = nil
    @ending_piece = nil
end