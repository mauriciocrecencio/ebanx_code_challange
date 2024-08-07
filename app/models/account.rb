class Account < ApplicationRecord
  validates :id, presence: true, uniqueness: true
  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def deposit(amount)
    update(balance: balance + amount)
  end

  def withdraw(amount)
    update(balance: balance - amount) if balance >= amount
  end
end