require_relative 'card'

class Deck
  attr_reader :cards

  RANKS = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze
  SUITS = %w[♣ ♥ ♠ ♦].freeze

  def initialize
    @cards = build_deck
  end

  def distribute
    @cards.pop
  end

  private

  def build_deck
    RANKS.flat_map do |rank|
      SUITS.collect do |suit|
        Card.new(rank, suit)
      end
    end.shuffle!
  end
end
