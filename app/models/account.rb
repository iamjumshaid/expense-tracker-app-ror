class Account < ApplicationRecord
	belongs_to :user
	has_many :transactions, as: :trans_from

	validates :name, uniqueness: { scope: :user_id,
    message: "This account already exists. Please create a unqiue account name." }

end
