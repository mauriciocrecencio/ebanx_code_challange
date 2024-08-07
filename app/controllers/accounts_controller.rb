# app/controllers/events_controller.rb
class AccountsController < ApplicationController
  def reset
    Account.delete_all
    head :ok
  end

  def balance
    account = Account.find_by(id: params[:account_id])
    if account
      render json: account.balance, status: :ok
    else
      render json: 0, status: :not_found
    end
  end
end
