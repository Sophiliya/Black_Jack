class Card
  attr_reader :name, :rank

  RANKS = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze
  SUITS = %w[♣ ♥ ♠ ♦].freeze

  def self.get_ranks
    RANKS
  end

  def self.get_suits
    SUITS
  end

  def initialize(rank, suit)
    @rank = rank
    @name = rank.to_s + suit
  end

  def point
    return 11 if @rank == 'Ace'
    (2..10).include?(@rank.to_i) ? @rank.to_i : 10
  end
end
