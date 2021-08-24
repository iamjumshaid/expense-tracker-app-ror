class WalletsController < ApplicationController

	def index

	end

	def show
		@wallet = Wallet.find(params[:id])
		authorize @wallet
	end

	def update
		@wallet = Wallet.find(params[:id])
		authorize @wallet
    if @wallet.update(wallet_params)
      flash[:info] = "Your wallet balance has been updated!"
			redirect_to wallet_path
    else
      flash[:alert] = "Unable to update the wallet balance!"
			redirect_to wallet_path
    end
	end

	private
	def wallet_params
		params.require(:wallet).permit(:current_amount)
	end

	 def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end
