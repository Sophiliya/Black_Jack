require_relative 'hand'

class Player
  attr_reader :cards, :name, :hand
  attr_accessor :bank

  def initialize(name = 'Player')
    @name = name
    @bank = Bank.new(self, 100)
    @hand = Hand.new(self)
  end

  def betting(amount, game_bank)
    @bank.deduct(amount)
    game_bank.add(amount)
  end

  def points
    @hand.count_points
  end
end

class Player::User < Player
end
class Player::Dealer < Player
end
