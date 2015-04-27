require 'sidekiq/web'

Rails.application.routes.draw do
  
  root :to => redirect('/entrar')

    
  devise_for :professionals, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'profissional/senha', confirmation: 'profissional/confirmar', unlock: 'profissional/desbloquear', sign_up: 'profissional/cadastrar' }, controllers: { sessions: 'sessions', registrations: 'devise/professional_registrations' }
  devise_for :customers, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'cliente/senha', confirmation: 'cliente/confirmar', unlock: 'cliente/desbloquear' }, controllers: { sessions: 'sessions', omniauth_callbacks: "customer_omniauth_callbacks" }, skip: ['registrations']
  
  as :customer do
    scope 'cliente' do
      root 'schedules#meus_servicos_por_profissionais', as: :customer_root
      get 'cadastrar', to: 'customers#new', as: :new_customer_registration
      post 'cadastrar', to: 'customers#create', as: :customer_registration

      get 'politica_privacidade', to: 'static_pages#privacy'

      resources :photo_logs, only: [:new, :create, :index, :destroy] do
        post 'send_to_fb', on: :collection
      end
    end
  end

  as :professional do
    scope 'profissional' do
      root 'schedules#new', as: :professional_root
      
      post :filter_by_email, to: 'customers#filter_by_email'
      post :filter_by_telefone, to: 'customers#filter_by_telefone'
      post 'get_customer_rewards/:customer_id', to: 'rewards#get_customer_rewards', as: :get_customer_rewards
      post 'notificacao', to: 'notifications#new', as: :new_notification
      get 'retorno-pagamento', to: 'notifications#retorno_pagamento', as: :retorno_pagamento
      resources :services
      resources :statuses
      resources :schedules do
        post :get_last_two_months_scheduled_customers, on: :collection
      end
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'
end
