require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = build_deck
  end

  def distribute
    @cards.pop
  end

  private

  def build_deck
    Card.get_ranks.flat_map do |rank|
      Card.get_suits.collect do |suit|
        Card.new(rank, suit)
      end
    end.shuffle!
  end
end
