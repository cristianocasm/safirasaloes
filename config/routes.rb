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
  end

  devise_for :customers, path: "cliente", path_names: { sign_in: 'entrar', sign_out: 'sair', password: 'senha', confirmation: 'confirmar', unlock: 'desbloquear', sign_up: 'cadastrar' }
  resources  :customers, path: "cliente"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
