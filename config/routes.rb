Rails.application.routes.draw do
  
  root :to => redirect('http://globo.com/') # Alterar pelo link do SafiraSalões
  
  scope 'profissional' do
    root 'schedules#new', as: :professional_root
    
    devise_for :professionals, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'senha', confirmation: 'confirmar', unlock: 'desbloquear', sign_up: 'cadastrar' }
    post :filter_by_email, to: 'customers#filter_by_email'
    post :filter_by_telefone, to: 'customers#filter_by_telefone'
    resources :services
    resources :statuses
    resources :schedules do
      post :get_last_two_months_scheduled_customers, on: :collection #/schedules/get_last_two_months_scheduled_customers
    end
  end

  scope 'cliente' do
    root 'photo_logs#new', as: :customer_root

    devise_for :customers, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'senha', confirmation: 'confirmar', unlock: 'desbloquear', sign_up: 'cadastrar' }
    resources :customers
    resources :photo_logs

    get 'ordem_de_troca/new/', to: 'schedules#new_exchange_order', as: :new_exchange_order
    post 'ordem_de_troca/new/', to: 'schedules#create_exchange_order', as: :create_exchange_order
  end
  
end
