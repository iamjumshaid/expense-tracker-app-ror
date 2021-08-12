class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :trans_type, null: false
      t.float  :amount, null: false
      t.datetime :date, null: false
      t.string   :description, null: false
      t.string :category
      t.integer :trans_to_id # for bank transfer only
      t.string :trans_to_type 

      t.references :trans_from, polymorphic: true

      t.timestamps
    end
  end
end
