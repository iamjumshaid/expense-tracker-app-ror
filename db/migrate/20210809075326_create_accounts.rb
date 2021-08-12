class CreateAccounts < ActiveRecord::Migration[6.1]
  def change

    create_table :accounts do |t|
      t.string :name
      t.float :current_amount
      t.timestamps
    end
  end

end
