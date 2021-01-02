# frozen_string_literal: true

# Main game loop
class Game
  def initialize
    @controller = Controller.new
    @file_controller = FileController.new
  end

  def start_game
    puts 'Game Begins!'
    @controller.answer = @file_controller.choose_answer
    while @controller.turns_left.positive? && @controller.winner == false
      @controller.update_play_field
      @controller.get_input
    end
    end_game
  end

  def end_game
    if @controller.winner == false
      puts "\nYOU LOSE!!!\n\n"
    else
      puts "\nYOU WIN!!!\n\n"
    end
  end

  def save_game; end

  def load_game; end
end

# Controls play field and game states
class Controller
  attr_accessor :answer, :guesses, :turns_left, :winner

  def initialize
    @play_field = PlayField.new
    @guesses = []
    @turns_left = 6
    @winner = false
  end

  def get_input
    puts 'Enter one letter as your guess: '
    input_accepted = false
    while input_accepted == false
      input = gets.upcase.chomp
      input_accepted = true if input.match(/[A-Z]/) && input.length == 1
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
    else
      @turns_left -= 1
    end
  end
end

# Read/Writes files
class FileController
  attr_accessor :config_file

  def initialize; end

  def choose_answer
    dictionary = File.readlines('5desk.txt')
    r = 1 + rand(dictionary.length)
    r = 1 + rand(dictionary.length) while (dictionary[r].length < 7) || (dictionary[r].length > 14)
    dictionary[r].chomp.upcase
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
game.start_game
