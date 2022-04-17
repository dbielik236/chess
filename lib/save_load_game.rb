# frozen_string_literal: true

require_relative 'game'
require 'yaml'

# saves and loads games

module SaveLoad

    def save_game(current_game)
        # need to prompt the user to give a filename
        filename = gets.chomp
        dump = YAML.dump(current_game)


