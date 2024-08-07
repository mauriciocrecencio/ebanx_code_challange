class DepositService
  def initialize(destination_id, amount)
    @destination_id = destination_id
    @amount = amount
  end

  def call
    account = Account.find_or_create_by(id: @destination_id)
    account.deposit(@amount)
    { status: :created, json: { destination: { id: account.id, balance: account.balance } } }
  end
end