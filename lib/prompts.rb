# frozen_string_literal: true

require_relative 'game'
require_relative 'board'
require_relative 'human'

# holds all the display prompts
module Display

  def welcome_prompt
    puts 'Let\'s play chess! To load a saved game type, l. To play a new game, type n.'
  end

  def new_or_load_error_prompt
    puts 'Please type l to load a saved game or type n to play a new game.'
  end

  def player_name_prompt
    puts 'What is your name?'
  end

  def player_color_prompt
    puts 'Which color do you choose? (enter b or w)'
  end

  def color_error_prompt
    puts 'Please choose a color by entering the letter b or w.'
  end

  def starting_piece_prompt
    puts "#{@human.name}, choose a piece to move (for example a1 or f7). (Type c to castle or s to save.)"
  end

  def illegal_starting_location_prompt
    puts 'You don\'t have a piece there. Please select again.'
  end

  def ending_square_prompt
    puts 'Choose a space to move the piece to (for example a1 or f7).'
  end

  def which_rook_to_castle_prompt
    puts 'Enter the location of the rook you would like to castle with.'
  end

  def illegal_ending_location_prompt
    puts 'Illegal move. Please select again. Or type p to choose another piece.'
  end

  def incorrect_format_prompt
    puts 'Enter a location first with row-letter then column-number (for example, a1 or f7). '
  end

  def path_not_clear_prompt
    puts 'Path not clear. Please choose again. Or type p to choose another piece.'
  end

  def illegal_move_for_piece_prompt
    puts 'That piece cannot go there. Please choose again. Or type p to choose another piece.'
  end

  def display_computer_making_turn
    print 'The computer is thinking'
  end

  def display_computer_turn
    puts "The computer moved from #{@starting_choice} to #{@ending_choice}."
  end

  def king_is_in_check_prompt
    puts 'Your king is in check. Your move must get the king out of check.'
  end

  def move_will_put_king_in_check_prompt
    puts 'That will put your king in check. Pick a new piece to move.'
  end

  def check_mate_prompt
    puts 'Checkmate!'
  end

  def cannot_castle_prompt
    puts 'You can\'t castle with that rook.'
  end

  def pawn_promote_prompt
    puts 'Your pawn is promoted! Type the first letter of the piece you would like it to become.'
  end

  def incorrect_piece_prompt
    puts 'Type q for queen, b for bishop, k for knight, or r for rook'
  end

  def display_piece_promoted
    puts 'Your pawn has been promoted!'
  end

  def computer_king_is_in_check_display
    puts "The computer\'s king is in check."
  end

  def file_name_prompt
    puts 'Please type a name to save the file under'
  end

  def saved_game_choices_prompt
    puts 'Here are the saved games. Which one would you like to load?'
  end

  def save_the_game_prompt
    puts 'Type s to save the game, otherwise hit enter to make a move.'
  end

  def game_has_been_saved_display
    puts 'Game saved successfully. Close out or hit enter to keep playing.'
  end

  def not_a_valid_choice_prompt
    puts 'You must choose one of the numbers listed.'
  end

  def play_again_prompt
    puts 'Would you like to play again? Type y or n.'
  end

  def thanks_for_playing_prompt
    puts 'Thanks for playing!'
  end
end
