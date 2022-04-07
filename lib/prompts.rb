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
    puts "Please choose your color (enter b or w)"
  end

  def color_error_prompt
    puts 'Please choose a color by entering the letter b or w.'
  end

  def starting_piece_prompt
    puts 'Please enter the LOCATION of the PIECE you\'d like to MOVE. (First type the column letter and then the row number. For example, a1, or f5.)'
  end

  def ending_square_prompt
    puts 'Please enter the LOCATION of the SQUARE where you\'d like to PLACE your piece. (First type the column letter and then the row number. For example, a1, or f5.)'
  end

  def incorrect_format_prompt
    puts 'Sorry! The format is incorrect. First type the column letter and then the row number. For example, a1, or f5.'
  end

  def illegal_location_prompt
    puts 'Sorry! That is not a viable location. Please select again.'
  end
end