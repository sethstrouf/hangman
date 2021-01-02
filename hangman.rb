# frozen_string_literal: true

require 'yaml'

# Main game loop
class Game
  def initialize
    @controller = Controller.new
    @file_controller = FileController.new
  end

  def start_new_game
    @controller.answer = @file_controller.choose_answer
    game_loop
  end

  def game_loop
    while @controller.turns_left.positive? && @controller.winner == false
      @controller.update_play_field
      @controller.get_input
      if @controller.save_and_quit == true
        save_game
        @controller.turns_left = 0
      end
    end
    @controller.update_play_field
    end_game
  end

  def end_game
    if @controller.save_and_quit == true
      puts "\nGAME SAVED"
    elsif @controller.winner == false
      puts "\nYOU LOSE!!!\n\n"
      puts "The Word was: #{@controller.answer}\n\n"
    elsif puts "\nYOU WIN!!!\n\n"
    end
  end

  def save_game
    @controller.save_and_quit = false
    yaml_string = YAML.dump(self)
    @controller.save_and_quit = true
    @file_controller.write_config(yaml_string)
  end

  def load_game
    yaml_string = @file_controller.load_config
    YAML.safe_load(yaml_string)
  end
end

# Controls play field and game states
class Controller
  attr_accessor :answer, :guesses, :turns_left, :winner, :save_and_quit

  def initialize
    @play_field = PlayField.new
    @guesses = []
    @turns_left = 6
    @winner = false
    @save_and_quit = false
  end

  def get_input
    puts 'Enter one letter as your guess (or 0 to save and quit): '
    input_accepted = false
    while input_accepted == false
      input = gets.upcase.chomp
      input_accepted = true if (input.match(/[A-Z]/) && input.length == 1) || input == '0'
    end
    check_match(input)
    answer_array = @answer.split('')
    @winner = true if answer_array - @guesses == []
  end

  def update_play_field
    @play_field.draw_field(answer, guesses, turns_left)
  end

  def check_match(input)
    if @guesses.include?(input)
      @turns_left -= 1
    elsif @answer.split('').include?(input)
      @guesses.push(input)
      @guesses = @guesses.uniq
    elsif input == '0'
      @save_and_quit = true
    else
      @turns_left -= 1
    end
  end
end

# Read/Writes files
class FileController
  def initialize; end

  def choose_answer
    dictionary = File.readlines('5desk.txt')
    r = 1 + rand(dictionary.length)
    r = 1 + rand(dictionary.length) while (dictionary[r].length < 7) || (dictionary[r].length > 14)
    dictionary[r].chomp.upcase
  end

  def write_config(yaml_string)
    config_file = File.open('saved_game.yml', 'w')
    config_file.puts(yaml_string)
    config_file.close
  end

  def load_config
    file = File.open('saved_game.yml')
    file.read
  end
end

# Draws the UI
class PlayField
  def initialize; end

  def draw_field(answer, guesses, turns_left)
    string = create_string(answer, guesses)
    puts "\n#{string}\n\n"
    puts "Turns left: #{turns_left}\n\n"
    guesses = guesses.sort.join(', ')
    puts "You have guessed: #{guesses}\n\n"
  end

  def create_string(answer, guesses)
    answer = answer.split('')
    letters_not_guessed = answer - guesses
    answer.each_with_index do |a, i|
      letters_not_guessed.each do |g|
        answer[i] = ' __ ' if a == g
      end
    end

    answer.join
  end
end

game = Game.new

if File.exist?('saved_game.yml')
  puts 'Enter 0 to load game or anything else to start a new game'
  if gets.chomp == '0'
    game = game.load_game
    game.game_loop
  else
    game.start_new_game
  end
end
