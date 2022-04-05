# frozen_string_literal: true

require_relative "game"
require_relative "board"

# Manages the color and legal moves of the Rook
class Rook
    attr_accessor :color
    attr_accessor :icon
    attr_accessor :move_count
  
    def initialize(color, icon)
      @color = color
      @icon = icon
      @move_count = 0
    end
  
    def legal_move?(start, finish)
      # any number of horizontal, vertical

      # castle only if king and rook haven't moved?
    end
  end
  