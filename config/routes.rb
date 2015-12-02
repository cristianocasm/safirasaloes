require 'sidekiq/web'

Rails.application.routes.draw do

  root :to => redirect('/entrar')
    
  devise_for :professionals, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'profissional/senha', confirmation: 'profissional/confirmar', unlock: 'profissional/desbloquear', sign_up: 'profissional/cadastrar' }, controllers: { sessions: 'sessions', registrations: 'devise/professional_registrations', confirmations: 'devise/professional_confirmations' }
  devise_for :customers, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'cliente/senha', confirmation: 'cliente/confirmar', unlock: 'cliente/desbloquear' }, controllers: { sessions: 'sessions' }, skip: ['registrations']

  as :customer do

    get "/auth/:provider/callback", :to => "omniauth_callbacks#facebook"
    get '/auth/failure', to: redirect('/')
    
    scope 'cliente' do
      root 'customers#minhas_safiras_por_profissionais', as: :customer_root
      get 'fotos/:token', to: 'photos#index', as: :my_photos
      post 'assign_rewards_to_customer', to: 'rewards#assign_rewards_to_customer', as: :assign_rewards_to_customer
    end
  end

  as :professional do
    
    get "/auth/:provider/callback", :to => "omniauth_callbacks#facebook"
    get '/auth/failure', to: redirect('/')
    
    scope 'profissional' do
      root 'photos#new', as: :professional_root

      resources :sign_up_steps, only: [:index, :show, :update]
      resources :photos, only: [:new, :create, :destroy]
      post 'get_rewards_by_customers_telephone/', to: 'rewards#get_rewards_by_customers_telephone', as: :get_rewards_by_customers_telephone
      post 'notificacao', to: 'notifications#new', as: :new_notification
    end
  end

  get 'retorno-pagamento', to: 'notifications#retorno_pagamento', as: :retorno_pagamento

  mount Sidekiq::Web, at: '/sidekiq'

  get ":site_slug", to: 'photos#my_site', as: :professionals_site

  # Esta rota TEM que ser a última da listagem, pois
  # seu objetivo é redirecionar o usuário para uma
  # página 404 no caso onde a rota não existe.
  match '*path', via: :all, to: 'static_pages#error_404'
end
