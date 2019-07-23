class Hand
  attr_reader :user, :cards

  def initialize(user)
    @user = user
    @cards = []
  end

  def cards_count
    @cards.count
  end

  def add_card(card)
    @cards << card
  end

  def count_points
    points_init = @cards.map(&:point).inject(:+)
    ace_point_change(points_init)
  end

  def cards_enough?
    cards_count == 2
  end

  def limit_reached?
    cards_count == 3
  end

  private

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
