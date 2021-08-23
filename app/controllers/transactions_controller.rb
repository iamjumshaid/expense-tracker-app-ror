class TransactionsController < ApplicationController

	def index
		@income_trans = current_user.transactions.income
    @expense_trans = current_user.transactions.expense
    @bt_trans = current_user.transactions.bank_transfer
	end

	def edit
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
  end



  def create
    if params[:transaction][:trans_type] == "income"

     # making unneccesary parameters for this transaction to be nill
     params[:transaction][:account_to] = nil
     params[:transaction][:expense_category] = nil
     params[:transaction][:trans_to_id] = nil
     params[:transaction][:trans_to_type] = nil
     
     add_income # adding the income to the account and make necessary transaction



    elsif params[:transaction][:trans_type] == "expense"
     params[:transaction][:account_to] = nil
     params[:transaction][:income_category] = nil
     add_expense # add expense to the account/wallet and make the transaction

    else
     params[:transaction][:expense_category] = nil
     params[:transaction][:income_category] = nil
     make_bank_transfer # do a bank transfer
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
		@transaction = Transaction.find(params[:id])
		# restore expenses or income code here restore_money()
    trans_amount = @transaction.amount.to_f 
 
    if @transaction.trans_from_type == "Account"
      # restore amount back in the account
      acc = @transaction.trans_from
      current_amount = acc.current_amount.to_f
      new_amount = trans_amount + current_amount
      acc.update(current_amount: new_amount)
    else 
      # restore amount back in the wallet
      current_amount = current_user.wallet.current_amount.to_f
      new_amount = trans_amount + current_amount
      current_user.wallet.update(current_amount: new_amount)
    end

    authorize @transaction
    if @transaction.destroy
      flash[:info] = "Transaction deleted and transaction amount restored!"
  		redirect_to transactions_path
    else
      flash[:alert] = "Unable to undo the transaction"
      redirect_to transactions_path
    end
	end




  private
  def add_income
     if params[:transaction][:account_from] == "Wallet"
            # add money in wallet
            user_amount =  params[:transaction][:amount].to_f
            current_amount = current_user.wallet.current_amount.to_f
            new_amount = user_amount + current_amount
            
            # create transaction from wallet
            if current_user.wallet.update(current_amount: new_amount)
              trans = current_user.wallet.transactions.create(
                      trans_type: params[:transaction][:trans_type], 
                      amount: params[:transaction][:amount], 
                      date: params[:transaction][:date], 
                      description: params[:transaction][:description], 
                      income_category: params[:transaction][:income_category], 
                      user_id: current_user.id)

              flash[:info] = "Transaction sucessful and income added to your wallet account!"
              redirect_to dashboard_index_path
            else 
              flash[:alert] = "Income failed to be added to your account!"
              redirect_to dashboard_index_path
            end
      else 
      # adding income in account
            account_name = params[:transaction][:account_from]
            acc = current_user.accounts.find_by(name: account_name)            

            user_amount =  params[:transaction][:amount].to_f
            current_amount = acc.current_amount.to_f

            new_amount = user_amount + current_amount
            
            if acc.update(current_amount: new_amount)
              # create transaction from account
              trans = acc.transactions.create(
                      trans_type: params[:transaction][:trans_type], 
                      amount: params[:transaction][:amount], 
                      date: params[:transaction][:date], 
                      description: params[:transaction][:description], 
                      income_category: params[:transaction][:income_category], 
                      user_id: current_user.id)
              flash[:info] = "Transaction successful and income added to your account!"
              redirect_to dashboard_index_path
            else 
              flash[:alert] = "Income failed to be added to your account!"
              redirect_to dashboard_index_path
            end
      end
  end


  def add_expense
     if params[:transaction][:account_from] == "Wallet"
            # expense from wallet
            user_amount =  params[:transaction][:amount].to_f
            current_amount = current_user.wallet.current_amount.to_f

            if current_amount >= user_amount
              new_amount = current_amount - user_amount
              current_user.wallet.update(current_amount: new_amount)
              trans = current_user.wallet.transactions.create(
                      trans_type: params[:transaction][:trans_type], 
                      amount: params[:transaction][:amount], 
                      date: params[:transaction][:date], 
                      description: params[:transaction][:description], 
                      expense_category: params[:transaction][:expense_category], 
                      user_id: current_user.id)
              flash[:info] = "Transaction sucessful and amount deducted from your wallet!"
              redirect_to dashboard_index_path
            else
              flash[:alert] = "You do not have enough balance to make this transcation"
              redirect_to dashboard_index_path
            end
      else 
      # expense from account
            account_name = params[:transaction][:account_from]
            acc = current_user.accounts.find_by(name: account_name)

            user_amount =  params[:transaction][:amount].to_f
            current_amount = acc.current_amount.to_f
            if current_amount >= user_amount
              new_amount = current_amount - user_amount
              acc.update(current_amount: new_amount)
              trans = acc.transactions.create(
                      trans_type: params[:transaction][:trans_type], 
                      amount: params[:transaction][:amount], 
                      date: params[:transaction][:date], 
                      description: params[:transaction][:description], 
                      expense_category: params[:transaction][:expense_category], 
                      user_id: current_user.id)
              flash[:info] = "Transaction sucessful and amount deducted from your account!"
              redirect_to dashboard_index_path
            else
              flash[:alert] = "You do not have enough balance to make this transcation"
              redirect_to dashboard_index_path
            end
      end
  end

  def make_bank_transfer
     if params[:transaction][:account_from] != params[:transaction][:account_to]

      if params[:transaction][:account_from] == "Wallet"
        # tranfer from wallet
        user_amount =  params[:transaction][:amount].to_f
        current_wallet_amount = current_user.wallet.current_amount.to_f
        
        account_name = params[:transaction][:account_to]
        acc = current_user.accounts.find_by(name: account_name)
        current_acc_amount = acc.current_amount

        if current_wallet_amount >= user_amount

          # taking money out from wallet
          new_wallet_amount = current_wallet_amount - user_amount

          # adding money in the account
          new_account_amount = current_acc_amount + user_amount


          # updating wallet and ammount
          current_user.wallet.update(current_amount: new_wallet_amount) 
          acc.update(current_amount: new_account_amount)

          # saving the transaction
          trans = current_user.wallet.transactions.create(
                      trans_type: params[:transaction][:trans_type], 
                      amount: params[:transaction][:amount], 
                      date: params[:transaction][:date], 
                      description: params[:transaction][:description], 
                      trans_to_id: acc.id,
                      trans_to_type: "Account",
                      user_id: current_user.id)
          flash[:info] = "Bank transfer sucessful!"
          redirect_to dashboard_index_path
        else
          flash[:alert] = "You do not have sufficient balance in your wallet"
          redirect_to dashboard_index_path
        end


      else
        # transfer from account

        # case 1: transfer from account to wallet
        if params[:transaction][:account_to] == "Wallet"
            user_amount =  params[:transaction][:amount].to_f
            account_name = params[:transaction][:account_from]

            acc_from = current_user.accounts.find_by(name: account_name)
            current_acc_amount = acc_from.current_amount
            current_wallet_amount = current_user.wallet.current_amount.to_f

            if current_acc_amount >= user_amount

              # taking money out from the accunt
              new_account_amount = current_acc_amount - user_amount

              # adding money in wallet
              new_wallet_amount = current_wallet_amount + user_amount


              # updating wallet and account
              current_user.wallet.update(current_amount: new_wallet_amount) 
              acc_from.update(current_amount: new_account_amount)

              # saving the transaction
              trans = acc_from.transactions.create(
                          trans_type: params[:transaction][:trans_type], 
                          amount: params[:transaction][:amount], 
                          date: params[:transaction][:date], 
                          description: params[:transaction][:description], 
                          trans_to_id: current_user.wallet.id,
                          trans_to_type: "Wallet",
                          user_id: current_user.id)
              flash[:info] = "Bank transfer sucessful!"
              redirect_to dashboard_index_path
            else
              flash[:alert] = "You do not have sufficient balance in your wallet"
              redirect_to dashboard_index_path
            end

        else # case 2: transfer from account to account
              user_amount =  params[:transaction][:amount].to_f
              account_from_name = params[:transaction][:account_from]
              account_to_name = params[:transaction][:account_to]

              acc_from = current_user.accounts.find_by(name: account_from_name)
              acc_to = current_user.accounts.find_by(name: account_to_name)

              current_acc_from_amount = acc_from.current_amount
              current_acc_to_amount = acc_to.current_amount

              if current_acc_from_amount >= user_amount

                # taking money out from the account
                new_account_from_amount = current_acc_from_amount - user_amount

                # adding money in other account
                new_account_to_amount = current_acc_to_amount + user_amount


                # updating both account
                acc_to.update(current_amount: new_account_to_amount) 
                acc_from.update(current_amount: new_account_from_amount)

                # saving the transaction
                trans = acc_from.transactions.create(
                            trans_type: params[:transaction][:trans_type], 
                            amount: params[:transaction][:amount], 
                            date: params[:transaction][:date], 
                            description: params[:transaction][:description], 
                            trans_to_id: current_user.wallet.id,
                            trans_to_type: "Account",
                            user_id: acc_to.id)
                flash[:info] = "Bank transfer sucessful!"
                redirect_to dashboard_index_path
              else
                flash[:alert] = "You do not have sufficient balance in your wallet"
                redirect_to dashboard_index_path
              end
        end
      end

     else
      flash[:alert] = "You can not transfer money within an account!"
      redirect_to dashboard_index_path
     end
  end


end

