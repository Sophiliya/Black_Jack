class Player
  attr_reader :cards, :name, :points
  attr_accessor :bank

  def initialize(name = 'Player')
    @name = name
    @cards = []
  end

  def cards_count
    @cards.count
  end

  def take_card(card)
    @cards << card
  end

  def show_cards
    @cards.map(&:name).join('  ')
  end

  def betting(amount, game_bank)
    @bank.deduct(amount)
    game_bank.add(amount)
  end

  def count_points
    points_init = @cards.map(&:point).inject(:+)
    @points = ace_point_change(points_init)
  end

  protected

  def ace_point_change(points_init)
    if ace_count == 1 && points_init <= 21
      points_init
    else
      points_init -= 10 * ace_count
    end
  end

  def ace_count
    @cards.select { |card| card.rank == 'Ace' }.count
  end
end
