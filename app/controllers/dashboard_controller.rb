class DashboardController < ApplicationController
	def index
    user_wallet = Wallet.find_by(user_id: current_user.id)
    if user_wallet.blank?
    	wallet = current_user.create_wallet
   	end
	end
end
