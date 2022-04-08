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
    puts 'Please choose your color (enter b or w)'
  end

  def color_error_prompt
    puts 'Please choose a color by entering the letter b or w.'
  end

  def starting_piece_prompt
    puts 'Choose a piece to move. (Example a1 or f7)'
  end

  def ending_square_prompt
    puts 'Choose a space to move the piece to. (Example a1 or f7)'
  end

  def incorrect_format_prompt
    puts 'Sorry! The format is incorrect. Enter row-letter then column-number. For example, a1 or f7.'
  end

  def illegal_location_prompt
    puts 'Sorry! That is not a viable location. Please select again.'
  end

  def illegal_move_for_piece_prompt
    puts 'Sorry! That piece can\'t move there. Please select viable location'
  end
end
