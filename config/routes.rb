Rails.application.routes.draw do

  devise_for :professionals, path: "profissional", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'senha', confirmation: 'confirmar', unlock: 'desbloquear', sign_up: 'cadastrar' }
  scope 'profissional' do
    root       'schedules#new'
    post :filter_by_email, to: 'customers#filter_by_email'
    post :filter_by_telefone, to: 'customers#filter_by_telefone'
    resources  :services
    resources  :statuses
    resources  :schedules do
      post :get_last_two_months_scheduled_customers, on: :collection #/schedules/get_last_two_months_scheduled_customers
    end
    resources :exchange_orders
  end

  devise_for :customers, path: "cliente", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'senha', confirmation: 'confirmar', unlock: 'desbloquear', sign_up: 'cadastrar' }
  resources  :customers, path: "cliente"
  
end
