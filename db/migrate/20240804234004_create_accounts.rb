class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.integer :balance, default: 0
      t.timestamps
    end
    # create an account with id 100 and balance 10
  end
end
