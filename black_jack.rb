require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'bank'
require_relative 'terminal_interface'

class BlackJack
  attr_reader :stop, :players, :dealer, :user, :winner, :bet_amount, :interface

  def initialize(interface)
    @bank = Bank.new(self)
    @players = []
    @bet_amount = 10
    @interface = interface
    @interface.game = self
    @interface.greeting
    create_user
    create_dealer
  end

  def start
    @stop = false
    betting
    create_deck
    card_distribution
    @interface.notify_starting
    @interface.show_cards
    game_process
    stop!
  end

  def game_process
    loop do
      break if @stop
      @interface.turn_to(@user)
      perform_user_action(@interface.get_user_action)
      @interface.show_cards
      break if @stop
      @interface.turn_to(@user)
      dealer_action
      @interface.show_cards
    end
  end

  def user_available_actions
    @actions = ['Пропустить', 'Открыть карты']
    @user.hand.limit_reached? ? @actions : @actions << 'Добавить карту'
  end

  def perform_user_action(action)
    @stop = true if action == 'Открыть карты'
    return if @stop
    take_card(@user) unless action == 'Пропустить'
    check_hand_cards
  end

  def dealer_action
    if @dealer.points < 14 && !@dealer.hand.limit_reached?
      take_card(@dealer)
    elsif @dealer.hand.limit_reached? || @dealer.points > 17
      'skip'
    else
      [ 'skip', take_card(@dealer) ].sample
    end
    check_hand_cards
  end

  def stop!
    define_winner
    @interface.stop
    start_again?(@interface.start_again?)
  end

  private

  def create_user
    @user = Player::User.new(@interface.get_user_name)
    @players << @user
  end

  def create_dealer
    @dealer = Player::Dealer.new('Dealer')
    @players << @dealer
  end

  def create_deck
    @deck = Deck.new
  end

  def card_distribution
    clear_player_cards

    until @dealer.hand.cards_enough? && @user.hand.cards_enough? do
      @dealer.hand.add_card(@deck.distribute)
      @user.hand.add_card(@deck.distribute)
    end
  end

  def betting
    @players.each do |player|
      player.betting(@bet_amount, @bank)
    end
  end

  def take_card(player)
    player.hand.add_card(@deck.distribute)
  end

  def check_hand_cards
    @stop = true if @dealer.hand.limit_reached? && @user.hand.limit_reached?
  end

  def define_winner
    @winner = define_winner!
    @winner.nil? ? dead_heat : reward_winner(winner)
  end

  def define_winner!
    players = @players.reject { |player| player.points > 21 }
    return if players.empty? || points_equal?
    players.max_by(&:points) == @user ? @user : @dealer
  end

  def dead_heat
    @players.each do |player|
      player.bank.add(@bet_amount)
      @bank.deduct(@bet_amount)
    end
  end

  def reward_winner(winner)
    winner.bank.add(@bank.amount)
    @bank.deduct(@bank.amount)
  end

  def points_equal?
    @user.points == @dealer.points
  end

  def clear_player_cards
    @user.hand.cards.clear
    @dealer.hand.cards.clear
  end

  def start_again?(answer)
    answer == 1 ? start : @interface.game_over
  end
end
