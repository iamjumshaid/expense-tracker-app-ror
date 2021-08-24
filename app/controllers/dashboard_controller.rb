class DashboardController < ApplicationController
	def index

=begin
    user_wallet = Wallet.find_by(user_id: current_user.id)
    if user_wallet.blank?
    	wallet = current_user.create_wallet
   	end 
=end

   # current_user.wallet.find_or_create_by(name: "Wallet")

    # TODO: find and create in single query
    user_wallet = Wallet.find_or_create_by(user_id: current_user.id)


   	@user_accounts = ["Wallet"]

    @transaction = Transaction.new
    @account_names = current_user.accounts.select(:name)
    @account_names.each do |acc_name|
    	@user_accounts << acc_name.name
    end
    puts @user_accounts

    @expense_trans = current_user.transactions.expense
    @income_trans = current_user.transactions.income
    @transactions = current_user.transactions

    @total_expense = current_user.transactions.expense.sum(:amount)
    @total_income = current_user.transactions.income.sum(:amount)

    @accounts_bal = current_user.accounts.sum(:current_amount)
    @wallet_bal = current_user.wallet.current_amount

    @total_bal = @accounts_bal.to_f + @wallet_bal.to_f
	end

end
