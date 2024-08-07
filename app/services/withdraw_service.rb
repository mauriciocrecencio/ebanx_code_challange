class WithdrawService
  def initialize(origin_id, amount)
    @origin_id = origin_id
    @amount = amount
  end

  def call
    account = Account.find_by(id: @origin_id)

    return { status: :not_found, json: 0 } if account.nil?
    return { status: :unprocessable_entity, json: { error: 'Insufficient funds' } } if account.balance.to_i < @amount

    account.withdraw(@amount)
    { status: :created, json: { origin: { id: account.id, balance: account.balance } } }
  end
end