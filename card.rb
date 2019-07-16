class Card
  attr_reader :name, :rank

  def initialize(rank, suit)
    @rank = rank
    @name = rank.to_s + suit
  end

  def point
    return 11 if @rank == 'Ace'
    (2..10).include?(@rank.to_i) ? @rank.to_i : 10
  end
end
