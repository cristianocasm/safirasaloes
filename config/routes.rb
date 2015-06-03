require 'sidekiq/web'

Rails.application.routes.draw do

  root :to => redirect('/entrar')
    
  devise_for :professionals, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'profissional/senha', confirmation: 'profissional/confirmar', unlock: 'profissional/desbloquear', sign_up: 'profissional/cadastrar' }, controllers: { sessions: 'sessions', registrations: 'devise/professional_registrations' }
  devise_for :customers, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'cliente/senha', confirmation: 'cliente/confirmar', unlock: 'cliente/desbloquear' }, controllers: { sessions: 'sessions', omniauth_callbacks: "customer_omniauth_callbacks" }, skip: ['registrations']
  devise_for :admins, path: "acesso_restrito", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'senha' }
  
  as :customer do
    scope 'cliente' do
      root 'schedules#meus_servicos_por_profissionais', as: :customer_root
      get 'cadastrar', to: 'customers#new', as: :new_customer_registration
      post 'cadastrar', to: 'customers#create', as: :customer_registration

      get 'politica_privacidade', to: 'static_pages#privacy'

      resources :photo_logs, only: [:new, :create, :index, :destroy] do
        post 'send_to_fb', on: :collection
      end

      resources :photo_log_steps
    end
  end

  as :professional do
    scope 'profissional' do
      root 'schedules#new', as: :professional_root
      
      post :filter_by_email, to: 'customers#filter_by_email'
      post :filter_by_telefone, to: 'customers#filter_by_telefone'
      post 'get_customer_rewards/:customer_id', to: 'rewards#get_customer_rewards', as: :get_customer_rewards
      post 'notificacao', to: 'notifications#new', as: :new_notification
      resources :services
      resources :statuses
      resources :schedules do
        post :get_last_two_months_scheduled_customers, on: :collection
      end
    end
  end

  as :admin do
    scope 'admin' do
      root 'dashboard#index', as: :admin_root
      put 'taken_steps', to: 'dashboard#taken_steps', as: :taken_steps
    end
  end

  get 'retorno-pagamento', to: 'notifications#retorno_pagamento', as: :retorno_pagamento

  mount Sidekiq::Web, at: '/sidekiq'

  # Esta rota TEM que ser a última da listagem, pois
  # seu objetivo é redirecionar o usuário para uma
  # página 404 no caso onde a rota não existe.
  match '*path', via: :all, to: 'static_pages#error_404'
end
