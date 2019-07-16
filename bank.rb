class Bank
  attr_reader :user, :amount

  def initialize(user, amount = 0)
    @user = user
    @amount = amount
    @user.bank = self unless user.is_a?(BlackJack)
  end

  def deduct(sum)
    @amount -= sum if @amount >= sum
  end

  def add(sum)
    @amount += sum
  end
end
