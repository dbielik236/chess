# frozen_string_literal: true

require_relative './lib/board'
require_relative './lib/game'
require_relative './lib/prompts'

include Display


game = Game.new


welcome_prompt
#game.establish_player
#game.establish_computer
#game.establish_current_player
#p game.king_is_in_check?
game.play_game
check_mate_prompt
