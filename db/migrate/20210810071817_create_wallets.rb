class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets do |t|
      t.float :current_amount, null: false, default: 0
      t.string :name, null: false, default: 'Wallet'
      t.timestamps
    end
  end
end
