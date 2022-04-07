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
end