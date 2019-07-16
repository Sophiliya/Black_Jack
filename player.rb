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

  def betting(amount)
    @bank.deduct(amount)
  end
end
