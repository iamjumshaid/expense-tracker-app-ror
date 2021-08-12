Rails.application.routes.draw do
  devise_scope :user do
    post 'users/sign_up', to: 'devise/registrations#create'
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  devise_for :users



  #routes for dashboard
  resources :dashboard


  # routes for accounts
  resources :accounts

  # routes for wallets
  resources :wallets

  # routes for transactions
  resources :transactions

  root to: "home#index"
end
