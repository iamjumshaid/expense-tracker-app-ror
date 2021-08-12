class AddIndexToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_index :accounts, ["user_id", "name"], :unique => true
  end
end

