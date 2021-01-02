class Game

  def initialize
    @controller = Controller.new()
    @file_controller = FileController.new()
  end

  def start_game
    puts "Game Begins!"

    @controller.answer = @file_controller.choose_answer
    @controller.update_play_field
  end

  def end_game
  end

  def save_game
  end

  def load_game
  end

end

class Controller
  attr_accessor :answer
  attr_accessor :guesses
  attr_accessor :turns_left

  def initialize
    @play_field = PlayField.new()
    @guesses = []
    @turns_left = 0
  end

  def update_play_field
    @play_field.draw_field(answer, guesses, turns_left)
  end
end

class FileController
  attr_accessor :config_file

  def initialize
  end

  def choose_answer
    dictionary = File.readlines('5desk.txt')
    r = 1 + rand(dictionary.length)
    while dictionary[r].length < 7 or dictionary[r].length > 14
      r = 1 + rand(dictionary.length)
    end
    return dictionary[r].chomp.upcase
  end
end

class PlayField
  def initialize
  end

  def draw_field(answer, guesses, turns_left)
    puts "** #{answer} **"
    string = create_string(answer, guesses)
    puts "\n#{string}\n\n"
    puts "Turns left: #{turns_left}\n\n"
    guesses = guesses.sort.join(", ")
    puts "You have guessed: #{guesses}\n\n"
  end

  def create_string(answer, guesses)
    answer = answer.split("")
    letters_not_guessed = answer - guesses
    answer.each_with_index do | a , i |
      letters_not_guessed.each do | g |
        if a == g
          answer[i] = " __ "
        else
        end
      end
    end

    return answer.join
  end

end

puts "HANGMAN.rb Started..."
game = Game.new()
game.start_game
puts "HANGMAN.rb Ended..."


# DONE - Read dictionary, pick random word w/ conditions, return to Controller
# DONE - draw_field - length fo answer, draw underscores for each w/ spaces
# DONE - Make sure guesses show up on screen
  # each letter of answer
    # each letter of guesses
      # if == nothing else __
#