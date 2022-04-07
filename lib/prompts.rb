# frozen_string_literal: true

# holds all the display prompts
module Display

  def welcome_prompt
    puts 'Let\'s play chess!'
  end

  def player_name_prompt
    puts 'What is your name?'
  end

  def player_color_prompt
    puts 'Choose your color (enter b or w)'
  end

  def color_error_prompt
    puts 'Please choose a color by entering the letter b or w.'
  end

  def starting_piece_prompt
    puts 'Please enter the location of the piece you\'d like to move. (for example, a1)'
  end

  def incorrect_location_format_prompt
    puts 'Oops! Please use the correct format. First type the column letter and then the row number. For example, a1, or f5'
  end

  def illegal_location
    puts 'Sorry! That is not a viable location. Please select again.'
  end
end