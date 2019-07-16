require_relative 'card'
require_relative 'deck'
require_relative 'dealer'
require_relative 'user'
require_relative 'bank'

class BlackJack
  def initialize
    @bank = Bank.new(self)
    @players = []
    @bet_amount = 10
  end

  def start
    puts 'Привет!'

    create_dealer
    create_user
    create_bank_accounts

    start_game
  end

  private

  def create_dealer
    @dealer = Dealer.new('Dealer')
    @players << @dealer
  end

  def create_user
    @user = User.new(get_user_name)
    @players << @user
  end

  def get_user_name
    puts 'Ваше имя:'
    gets.chomp.strip
  end

  def create_bank_accounts
    @players.each { |player| Bank.new(player, 100) }
  end

  def start_game
    puts "Игра началась!"

    create_deck
    card_distribution
    show_to_user
    betting

    user_action
  end

  def create_deck
    @deck = Deck.new
  end

  def card_distribution
    clear_player_cards
    puts 'Раздача карт:'

    2.times do
      take_card(@dealer)
      take_card(@user)
    end
  end

  def show_to_user
    puts "Карты #{@dealer.name}: #{@dealer.show_cards_hidden}"
    puts "Карты #{@user.name}: #{@user.show_cards}, очки: #{@user.count_points}"
  end

  def betting
    @players.each do |player|
      player.betting(@bet_amount, @bank)
      puts "Ставка #{player.name}: $#{@bet_amount}"
    end
  end

  def user_action
    show_available_actions
    user_choice = @actions[gets.chomp.strip.to_i - 1]

    return stop_game if user_choice == 'Открыть карты'
    user_choice == 'Пропустить' ? skip_turn(@user) : take_card(@user)

    show_to_user
    give_turn_to(@dealer)
  end

  def give_turn_to(player)
    return stop_game if ( @dealer.cards_count == 3 && @user.cards_count == 3 )
    player == @user ? user_action : dealer_action
  end

  def dealer_action
    puts " => Ход диллера."
    dealer_choice
    show_to_user

    give_turn_to(@user)
  end

  def dealer_choice
    if @dealer.points < 14 && @dealer.cards_count < 3
      take_card(@dealer)
    elsif @dealer.cards_count == 3 || @dealer.points > 16
      skip_turn(@dealer)
    else
      [ skip_turn(@dealer), take_card(@dealer) ].sample
    end
  end

  def show_available_actions
    puts ' => Ваш ход. Выберите действие:'

    @actions = ['Пропустить', 'Открыть карты']
    @user.cards_count < 3 ? @actions << 'Добавить карту' : @actions
    @actions.each.with_index(1) { |action, index| puts "#{index}. #{action}" }
  end

  def take_card(player)
    player.take_card(@deck.distribute)
    player.count_points

    puts "    #{player.name} добавил карту."
  end

  def skip_turn(player)
    puts "    #{player.name} пропустил ход."
  end

  def stop_game
    puts 'Игра завершена.'

    results
    start_again?
  end

  def results
    @players.each do |player|
      puts "#{player.name}: #{player.show_cards}, очки: #{player.points}"
    end

    show_winner

    @players.each do |player|
      puts "#{player.name}: доступно $#{player.bank.amount}"
    end
  end

  def show_winner
    winner = define_winner
    winner.nil? ? dead_heat : reward_winner(winner)
  end

  def define_winner
    players = @players.reject { |player| player.points > 21 }
    return if players.empty? || points_equal?
    players.max_by(&:points) == @user ? @user : @dealer
  end

  def dead_heat
    puts "Ничья."

    @players.each do |player|
      player.bank.add(@bet_amount)
      @bank.reduce(@bet_amount)
    end
  end

  def reward_winner(winner)
    puts "Выйграл #{winner.name}."
    winner.bank.add(@bank.amount)
    @bank.deduct(@bank.amount)
  end

  def points_equal?
    @user.points == @dealer.points
  end

  def start_again?
    answer_to_start == 1 ? start_game : end_game
  end

  def answer_to_start
    ask_to_start
    gets.chomp.strip.to_i
  end

  def ask_to_start
    puts "#{@user.name}, продолжить игру?"
    puts 'Введите:  1. Да  2. Нет'
  end

  def clear_player_cards
    @user.cards.clear
    @dealer.cards.clear
  end

  def end_game
    puts "Пока, #{@user.name}!"
  end
end

game = BlackJack.new
game.start
