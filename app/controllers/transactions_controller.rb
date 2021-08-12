class TransactionsController < ApplicationController

	def index
		@user_transactions = current_user.transactions
	end



	def edit
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
    @user_accounts = current_user.accounts
    @user_wallet = current_user.wallet
  end

  def create
    @article = Article.new(title: "...", body: "...")

    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def update
    @trans = Transaction.find(params[:id])

    if @trans.update(trans_params)
      flash[:info] = "Transaction has been updated!"
			redirect_to transactions_path
    else
    	flash[:info] = "Unable to update your transaction, please check values!"
      render :edit
    end
  end

  def destroy
		@trans = Transaction.find(params[:id])
		# restore expenses or income code here restore_money()
    @trans.destroy
    flash[:info] = "Transaction deleted!"
		redirect_to transactions_path
	end




  private
	def trans_params
		params.require(:transaction).permit(:category, :trans_type, :amount, :date, :description)
	end
end
