require_relative 'black_jack'

class TerminalInterface
  def initialize
    greeting
    @game = BlackJack.new
    @dealer = @game.create_dealer
    @user = @game.create_user(get_user_name)
  end

  def start
    @game.start
    notify_starting
    show_cards
    game_process

    @game.stop!
    notify_ending
    show_cards(false)
    announce_winner
    show_bank_status
    start_again?
  end

  private

  def greeting
    puts "Привет!"
  end

  def notify_starting
    puts "Ставка: $#{@game.bet_amount}"
    puts "Игра началась!"
  end

  def notify_ending
    puts "Игра завершена!"
  end

  def get_user_name
    puts 'Ваше имя:'
    user_name = gets.chomp.strip
  end

  def show_cards(hidden = true)
    dealer_cards = @dealer.hand.cards.collect { '*' }.join(' ')
    dealer_cards = @dealer.hand.cards.map(&:name).join('  ') unless hidden
    dealer_points = hidden ? '*' : @dealer.points
    user_cards = @user.hand.cards.map(&:name).join('  ')
    puts "Карты #{@dealer.name}: #{dealer_cards}, очки: #{dealer_points}"
    puts "Карты #{@user.name}: #{user_cards}, очки: #{@user.points}"
  end

  def game_process
    loop do
      break if @game.stop
      @game.perform_user_action(get_user_action)
      show_cards
      break if @game.stop
      perform_dealer_action
      show_cards
    end
  end

  def get_user_action
    puts ' => Ваш ход. Выберите действие:'
    user_actions = @game.user_available_actions
    user_actions.each.with_index(1) do |action, index|
      puts "#{index}. #{action}"
    end
    user_actions[gets.chomp.strip.to_i - 1]
  end

  def perform_dealer_action
    puts ' => Ход диллера.'
    cards_count = @dealer.hand.cards_count
    @game.dealer_action

    if cards_count == @dealer.hand.cards_count
      puts "#{@dealer.name} пропустил ход."
    else
      puts "#{@dealer.name} добавил карту."
    end
  end

  def show_bank_status
    @game.players.each do |player|
      puts "#{player.name}: доступно $#{player.bank.amount}"
    end
  end

  def announce_winner
    puts @game.winner ? "Выйграл #{@game.winner.name}." : "Ничья."
  end

  def start_again?
    puts "#{@user.name}, продолжить игру?"
    puts 'Введите:  1. Да  2. Нет'
    answer = gets.chomp.strip.to_i
    answer == 1 ? start : game_over
  end

  def game_over
    puts 'Пока.'
  end
end
