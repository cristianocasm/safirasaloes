require 'sidekiq/web'

Rails.application.routes.draw do
  
  root :to => redirect('/entrar')
    
  devise_for :professionals, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'profissional/senha', confirmation: 'profissional/confirmar', unlock: 'profissional/desbloquear', sign_up: 'profissional/cadastrar' }, controllers: { sessions: 'sessions', registrations: 'devise/professional_registrations' }
  devise_for :customers, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'cliente/senha', confirmation: 'cliente/confirmar', unlock: 'cliente/desbloquear' }, controllers: { sessions: 'sessions' }, skip: ['registrations']
  
  as :customer do
    scope 'cliente' do
      root 'photo_logs#new', as: :customer_root
      get 'cadastrar', to: 'customers#new', as: :new_customer_registration
      post 'cadastrar', to: 'customers#create', as: :customer_registration
      get 'meus_servicos', to: 'schedules#meus_servicos_por_profissionais', as: :meus_servicos

      resources :photo_logs
    end
  end

  as :professional do
    scope 'profissional' do
      root 'schedules#new', as: :professional_root
      
      post :filter_by_email, to: 'customers#filter_by_email'
      post :filter_by_telefone, to: 'customers#filter_by_telefone'
      post 'get_customer_rewards/:customer_id', to: 'rewards#get_customer_rewards', as: :get_customer_rewards
      resources :services
      resources :statuses
      resources :schedules do
        post :get_last_two_months_scheduled_customers, on: :collection
      end
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'
end
