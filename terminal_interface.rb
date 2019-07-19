require_relative 'black_jack'

class TerminalInterface
  attr_accessor :game

  def greeting
    puts "Привет!"
  end

  def get_user_name
    puts 'Ваше имя:'
    user_name = gets.chomp.strip
  end

  def notify_starting
    puts "Игра началась!"
  end

  def show_cards(hidden = true)
    dealer_cards = game.dealer.hand.cards.collect { '*' }.join(' ')
    dealer_cards = game.dealer.hand.cards.map(&:name).join('  ') unless hidden
    dealer_points = hidden ? '*' : game.dealer.points
    user_cards = game.user.hand.cards.map(&:name).join('  ')
    puts "Карты #{game.dealer.name}: #{dealer_cards}, очки: #{dealer_points}"
    puts "Карты #{game.user.name}: #{user_cards}, очки: #{game.user.points}"
  end

  def turn_to(player)
    if player == game.user
      puts ' => Ваш ход. Выберите действие:'
    else
      puts ' => Ход диллера.'
    end
  end

  def get_user_action
    user_actions = game.user_available_actions
    user_actions.each.with_index(1) do |action, index|
      puts "#{index}. #{action}"
    end
    user_actions[gets.chomp.strip.to_i - 1]
  end

  def stop
    notify_ending
    show_cards(false)
    announce_winner
    show_bank_status
  end

  def notify_ending
    puts "Игра завершена!"
  end

  def announce_winner
    puts game.winner ? "Выйграл #{game.winner.name}." : "Ничья."
  end

  def show_bank_status
    game.players.each do |player|
      puts "#{player.name}: доступно $#{player.bank.amount}"
    end
  end

  def start_again?
    puts "#{game.user.name}, продолжить игру?"
    puts 'Введите:  1. Да  2. Нет'
    answer = gets.chomp.strip.to_i
  end

  def game_over
    puts 'Пока.'
  end
end
