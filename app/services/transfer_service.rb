class TransferService
  def initialize(origin_id, destination_id, amount)
    @origin_id = origin_id
    @destination_id = destination_id
    @amount = amount
  end

  def call
    origin = Account.find_by(id: @origin_id)
    destination = Account.find_or_create_by(id: @destination_id)

    return { status: :not_found, json: 0 } if origin.nil? || destination.nil?
    return { status: :unprocessable_entity, json: { error: 'Insufficient funds' } } if origin.balance.to_i < @amount

    ActiveRecord::Base.transaction do
      origin.withdraw(@amount)
      destination.deposit(@amount)
    end
    { status: :created, json: { origin: { id: origin.id, balance: origin.balance }, destination: { id: destination.id, balance: destination.balance } } }
  end
end