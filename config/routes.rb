Rails.application.routes.draw do
  
  root :to => redirect('/entrar') # Alterar pelo link do SafiraSalões
    
  devise_for :professionals, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'senha', confirmation: 'confirmar', unlock: 'desbloquear', sign_up: 'cadastrar' }, controllers: { sessions: 'sessions', registrations: 'registrations' }
  devise_for :customers, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'senha', confirmation: 'confirmar', unlock: 'desbloquear', sign_up: 'cadastrar' }, controllers: { sessions: 'sessions', registrations: 'registrations' }
  
  scope 'profissional' do
    root 'schedules#new', as: :professional_root
    
    post :filter_by_email, to: 'customers#filter_by_email'
    post :filter_by_telefone, to: 'customers#filter_by_telefone'
    resources :services
    resources :statuses
    resources :schedules do
      post :get_last_two_months_scheduled_customers, on: :collection #/schedules/get_last_two_months_scheduled_customers
      post :accept_exchange_order, on: :collection
    end
  end

  scope 'cliente' do
    root 'photo_logs#new', as: :customer_root

    resources :customers
    resources :photo_logs

    get 'ordem_de_troca/new/', to: 'schedules#new_exchange_order', as: :new_exchange_order
    post 'ordem_de_troca/new/', to: 'schedules#create_exchange_order', as: :create_exchange_order
  end
  
end
