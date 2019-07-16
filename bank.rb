class Bank
  attr_reader :user, :amount

  def initialize(user = 'Black Jack', amount = 0)
    @user = user
    @amount = amount
    @user.bank = self unless user == 'Black Jack'
  end

  def deduct(sum)
    @amount -= sum if @amount > sum
  end

  def add(sum)
    @amount += sum
  end
end
