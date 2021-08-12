class AccountsController < ApplicationController
  def index
  	@user_accounts = current_user.accounts
  	@account = Account.new
	end

	def create
		puts current_user.email
		@account = current_user.accounts.new(account_params)
		if @account.save
			flash[:info] = "Account has been created succesfully!"
			redirect_to accounts_path
		else
			#flash[:alert] = @account.errors.first.full_message
			flash[:alert] = @account.errors[:name]
			redirect_to accounts_path
		end
	end

	def show
	end

	def edit
    @acc = Account.find(params[:id])
  end

   def update
    @acc = Account.find(params[:id])

    if @acc.update(account_params)
      flash[:info] = "Account details has been updated!"
			redirect_to accounts_path
    else
      render :edit
    end
  end

	def destroy
		@acc = Account.find(params[:id])
    @acc.destroy
    flash[:info] = "Account deleted!"
		redirect_to accounts_path
	end

	private
	def account_params
		params.require(:account).permit(:name, :current_amount)
	end
end
