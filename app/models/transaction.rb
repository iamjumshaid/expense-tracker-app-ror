class Transaction < ApplicationRecord
	belongs_to :trans_from, polymorphic: true
	belongs_to :user	
end
