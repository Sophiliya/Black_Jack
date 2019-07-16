require_relative 'player'

class Dealer < Player
  def show_cards_hidden
    cards.collect { '*' }.join(' ')
  end
end
