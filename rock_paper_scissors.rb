module Screen
  def self.clear
    print "\e[2J\e[f"
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def >(other_move)
    beats.include? other_move.value
  end

  def to_s
    @value
  end

  def attacks(other_move)
    puts "The #{@value} #{@beats[other_move.value]} the #{other_move.value}!"
  end

  protected

  attr_reader :value, :beats
end

class Rock < Move
  def initialize
    @value = 'rock'
    @beats = { 'scissors' => 'smashes', 'lizard' => 'crushes' }
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
    @beats = { 'rock' => 'covers', 'spock' => 'disproves' }
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
    @beats = { 'paper' => 'cuts', 'lizard' => 'decapitates' }
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
    @beats = { 'paper' => 'eats', 'spock' => 'poisons' }
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
    @beats = { 'rock' => 'vaporizes', 'scissors' => 'disassembles' }
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def make_move(move)
    case move
    when 'rock'
      Rock.new
    when 'paper'
      Paper.new
    when 'scissors'
      Scissors.new
    when 'lizard'
      Lizard.new
    when 'spock'
      Spock.new
    end
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts "Please select rock, paper, scissors, lizard, or spock."
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, that is not a valid choice."
    end
    self.move = make_move(choice)
  end

  def set_name
    n = ''
    loop do
      puts "What is your name?"
      n = gets.chomp
      break if n.empty? == false
      puts "You must enter a name."
    end
    self.name = n
  end
end

class Computer < Player
  def choose
    self.move = make_move(Move::VALUES.sample)
  end

  def set_name
    self.name = ['Jerry', 'Hugh', 'Chad', 'Bozo', 'Mario', 'Jesus'].sample
  end
end

module Display
  def display_welcome_message
    puts "Hello. Welcome to rock, paper, scissors, lizard, spock."
  end

  def display_goodbye_message
    puts "Thank you for playing rock, paper, scissors, lizard, spock. Farewell."
  end

  def display_round_winner
    if human.move > computer.move
      human.move.attacks(computer.move)
    elsif computer.move > human.move
      computer.move.attacks(human.move)
    else
      puts "It's a tie."
    end
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_game_winner
    if human.score >= 3
      puts "#{human.name} has won the game!"
    elsif computer.score >= 3
      puts "#{computer.name} has won the game!"
    end
  end

  def display_score
    puts "#{human.name} has #{human.score} points."
    puts "#{computer.name} has #{computer.score} points."
  end

  def display_round_number
    puts "**********ROUND #{round_count}**********"
  end
end

# Game Engine
class RPSGame
  include Display
  include Screen

  attr_accessor :human, :computer, :round_count

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round_count = 1
  end

  def play_again?
    answer = ''
    loop do
      puts "would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Please enter y or n."
    end

    return true if answer == 'y'
    false
  end

  def update_score
    if human.move > computer.move
      human.score += 1
    elsif computer.move > human.move
      computer.score += 1
    end
  end

  def three_points?
    (human.score >= 3) || (computer.score >= 3)
  end

  def reset_game
    human.score = 0
    computer.score = 0
    self.round_count = 1
  end

  def increase_round_count
    self.round_count += 1
  end

  def play
    display_welcome_message
    loop do
      loop do
        display_round_number
        human.choose
        computer.choose
        sleep(1)
        display_moves
        sleep(1)
        display_round_winner
        sleep(3)
        Screen.clear
        update_score
        display_score
        display_game_winner if three_points?
        break if three_points?
        increase_round_count
      end
      break unless play_again?
      reset_game
    end
    display_goodbye_message
    sleep(3)
    Screen.clear
  end
end

RPSGame.new.play
