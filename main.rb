# frozen_string_literal: true

require_relative './lib/board'
require_relative './lib/game'
require_relative './lib/prompts'
require_relative './lib/save_load_game'

include Display
include SaveLoad

def play_chess
  welcome_prompt
  option = gets.chomp
  until option == 'n' || option == 'l'
    new_or_load_error_prompt
    option = gets.chomp
  end
  if option == 'n'
    game = Game.new
    game.establish_game
    game.play_game
  elsif option == 'l'
    game = load_game
    game.play_game
  end
  check_mate_prompt
end

play_chess
