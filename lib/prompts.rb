# frozen_string_literal: true

require_relative 'game'

# holds all the display prompts
module Display

  def welcome_prompt
    puts 'Let\'s play chess!'
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
    puts "#{@human.name}, choose a piece to move (for example a1 or f7)."
  end

  def illegal_starting_location_prompt
    puts 'You don\'t have a piece there. Please select again.'
  end

  def ending_square_prompt
    puts 'Choose a space to move the piece to (for example a1 or f7).'
  end

  def illegal_ending_location_prompt
    puts 'Illegal move. Please select again.'
  end

  def incorrect_format_prompt
    puts 'The format is incorrect. Enter row-letter then column-number (for example, a1 or f7).'
  end

  def path_not_clear_prompt
    puts 'Path not clear. Please choose again. If you are stuck, type p to choose another piece.'
  end

  def illegal_move_for_piece_prompt
    puts 'That piece cannot go there. Please choose again.'
  end
end
