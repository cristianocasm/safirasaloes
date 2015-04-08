Rails.application.routes.draw do
  
  root :to => redirect('/entrar')
    
  devise_for :professionals, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'profissional/senha', confirmation: 'profissional/confirmar', unlock: 'profissional/desbloquear', sign_up: 'profissional/cadastrar' }, controllers: { sessions: 'sessions' }
  devise_for :customers, path: "", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'cliente/senha', confirmation: 'cliente/confirmar', unlock: 'cliente/desbloquear', sign_up: 'cliente/cadastrar' }, controllers: { sessions: 'sessions' }
  
  scope 'profissional' do
    root 'schedules#new', as: :professional_root
    
    post :filter_by_email, to: 'customers#filter_by_email'
    post :filter_by_telefone, to: 'customers#filter_by_telefone'
    post 'get_customer_rewards/:customer_id', to: 'rewards#get_customer_rewards', as: :get_customer_rewards
    resources :services
    resources :statuses
    resources :schedules, except: [:update] do
      post :get_last_two_months_scheduled_customers, on: :collection # profissional/schedules/get_last_two_months_scheduled_customers
    end
  end

  scope 'cliente' do
    root 'photo_logs#new', as: :customer_root

    resources :customers
    resources :photo_logs

    get :meus_servicos, to: 'schedules#meus_servicos_por_profissionais', as: :meus_servicos
  end
  
end
