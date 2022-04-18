# frozen_string_literal: true

require_relative 'game'
require_relative 'board'
require_relative 'prompts'
require 'yaml'

# saves and loads games
module SaveLoad
  include Display

  def save_game(current_game)
    file_name_prompt
    filename = gets.chomp
    dump = YAML.dump(current_game)
    File.open(File.join(Dir.pwd, "/lib/saved_games/#{filename}.yaml"), 'w') { |file| file.write dump }
    game_has_been_saved_display
  end

  def choose_game
    saved_game_choices_prompt
    choices = []
    dir = './lib/saved_games'
    files = Dir.glob(File.join(dir, '**', '*')).select { |file| File.file?(file) }
    files.each_with_index do |f, index|
      choices << index
      puts "#{index + 1}.) #{f}"
    end
    # need to limit the answers to get here
    choice = gets.chomp
    until choices.include?(choice.to_i - 1)
      not_a_valid_choice_prompt
      choice = gets.chomp
    end
    files.each_with_index do |f, index|
      if index == choice.to_i - 1
        @filename = f
      end
    end
    @filename
  end

  def load_game
    filename = choose_game
    saved = File.open(File.join(filename), 'r')
    loaded_game = YAML.load(saved)
    saved.close
    loaded_game
  end
end
