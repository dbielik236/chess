# frozen_string_literal: true

require_relative './lib/board'
require_relative './lib/game'
require_relative './lib/prompts'
require_relative './lib/save_load_game'

include Display
include SaveLoad
welcome_prompt
option = gets.chomp
until option == 'n' || option == 'l'
  new_or_load_error_prompt
  option = gets.chomp
end
if option == 'n'
  game = Game.new
  game.board.display
  game.establish_player
  game.establish_computer
  game.establish_current_player
  # first turn to start the game
  game.first_turn
  until game.check_mate?
   game.one_turn
   if @current_player == @computer
     display_computer_making_turn
     sleep(0.25)
     print "."
     sleep(0.25)
     print "."
     sleep(0.25)
     print ".\n"
     sleep(0.25)
   end
   game.board.display
   if @current_player == @computer
     display_computer_turn
   end
   if @current_player == @human
     game.pawn_promotion_human
   elsif @current_player == @computer
     game.promote_piece('q')
   end
   if @current_player == @human
     save_the_game_prompt
     choice = gets.chomp
     if choice == 's'
       save_game(game)
     else
       puts 'Game not saved.'
     end
   end
   game.switch_current_player
  end
elsif option == 'l'
  game = load_game
  until game.check_mate?
    game.one_turn
    if @current_player == @computer
      display_computer_making_turn
      sleep(0.25)
      print "."
      sleep(0.25)
      print "."
      sleep(0.25)
      print ".\n"
      sleep(0.25)
    end
    game.board.display
    if @current_player == @computer
      display_computer_turn
    end
    if @current_player == @human
      game.pawn_promotion_human
    elsif @current_player == @computer
      game.promote_piece('q')
    end
    if @current_player == @human
      save_the_game_prompt
      choice = gets.chomp
      if choice == 's'
        save_game(game)
      else
        puts 'Game not saved.'
      end
    end
    game.switch_current_player
   end
end
check_mate_prompt
