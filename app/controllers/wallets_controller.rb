class WalletsController < ApplicationController

	def index

	end

	def show
		@wallet = Wallet.find(params[:id])
	end

	def update
		@wallet = Wallet.find(params[:id])

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

end
