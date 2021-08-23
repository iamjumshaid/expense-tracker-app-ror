class Transaction < ApplicationRecord
	belongs_to :trans_from, polymorphic: true
	belongs_to :user	

	enum trans_type: { income: "income", expense: "expense", bank_transfer: "bank transfer" }

	enum expense_category: { food: "food", travel: "travel", entertainment: "entertainment", 
													 medical: "medical", rent: "rent" }

	enum income_category: { salary: "salary", 
													freelance: "freelance", 
													passive: "passive",
													trade: "trade", 
													stocks: "stocks",
													bonds: "bonds"}
end
