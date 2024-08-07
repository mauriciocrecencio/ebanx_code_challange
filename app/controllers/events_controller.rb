# app/controllers/events_controller.rb
class EventsController < ApplicationController
  def reset
    Account.delete_all
    head :ok
  end

  def create
    result = handle_event(params[:type], params)
    render json: result[:json], status: result[:status]
  end

  private

  def handle_event(type, params)
    case type
      when 'deposit'
        DepositService.new(params[:destination], params[:amount].to_i).call
      when 'withdraw'
        WithdrawService.new(params[:origin], params[:amount].to_i).call
      when 'transfer'
        TransferService.new(params[:origin], params[:destination], params[:amount].to_i).call
    else
      { status: :unprocessable_entity, json: { error: 'Invalid event type' } }
    end
  end
end
