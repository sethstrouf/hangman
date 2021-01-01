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

  def initialize
    @play_field = PlayField.new()
  end

  def update_play_field
    @play_field.draw_field(answer)
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
      puts "Re-rolling"
      r = 1 + rand(dictionary.length)
    end
    return dictionary[r].chomp
  end
end

class PlayField
  def initialize
  end

  def draw_field(answer)
    puts "** #{answer} **"
  end
end

puts "HANGMAN.rb Started..."
game = Game.new()
game.start_game
puts "HANGMAN.rb Ended..."


# DONE - Read dictionary, pick random word w/ conditions, return to Controller
#