# frozen_string_literal: true

require_relative './lib/board'
require_relative './lib/game'
require_relative './lib/prompts'

include Display

welcome_prompt

game = Game.new
@board.display
game.play_game