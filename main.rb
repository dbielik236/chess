# frozen_string_literal: true

require_relative './lib/board'
require_relative './lib/game'
require_relative './lib/prompts'

include Display


game = Game.new


welcome_prompt

game.play_game
check_mate_prompt
