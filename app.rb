require_relative 'black_jack'

class App
  def initialize
    @game = BlackJack.new
    @dealer = @game.create_dealer
    @user = create_user
    start
  end

  private

  def start
    @game.start
    puts "Игра началась!"
    show_to_user

    loop do
      break if @game.stop
      perform_player_action
    end

    show_results
    start_again?
  end

  def create_user
    puts 'Привет!'
    puts 'Ваше имя:'
    user_name = gets.chomp.strip
    @game.create_user(user_name)
  end

  def show_to_user
    puts "Карты #{@dealer.name}: #{@dealer.show_cards_hidden}"
    puts "Карты #{@user.name}: #{@user.show_cards}, очки: #{@user.points}"
  end

  def perform_player_action
    user_action
    show_to_user
    return if @game.stop
    puts " => Ход диллера."
    @game.dealer_action
    show_to_user
    return if @game.stop
  end

  def user_action
    puts ' => Ваш ход. Выберите действие:'
    user_actions = @game.user_available_actions
    user_actions.each.with_index(1) do |action, index|
      puts "#{index}. #{action}"
    end

    user_action = user_actions[gets.chomp.strip.to_i - 1]
    @game.perform_user_action(user_action)
  end

  def show_results
    puts 'Игра завершена.'
    show_points

    @game.define_winner
    puts @game.winner ? "Выйграл #{@game.winner.name}." : "Ничья."
    show_bank_status
  end

  def show_points
    @game.players.each do |player|
      puts "#{player.name}: #{player.show_cards}, очки: #{player.points}"
    end
  end

  def show_bank_status
    @game.players.each do |player|
      puts "#{player.name}: доступно $#{player.bank.amount}"
    end
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

# app = App.new.initialize
