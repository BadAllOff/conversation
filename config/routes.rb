Rails.application.routes.draw do

  get 'authentications/index'
  get 'authentications/create'
  get 'authentications/destroy'

  get 'group_members/join/:group_id' => 'group_members#join', as:   :join_group
  get 'group_members/leave/:group_id' => 'group_members#leave', as: :leave_group
  get 'group_members/accept_member/:group_id/:user_id' => 'group_members#accept_member', as: :accept_member_to_group
  get 'group_members/decline_member/:group_id/:user_id' => 'group_members#decline_member', as: :decline_member_from_group

  resources :groups do
    collection do
      get 'show_all'
      get 'my'
    end

    member do
      get "show_map"
    end
  end
  devise_for :users, controllers: {omniauth_callbacks: "authentications", registrations: "registrations"}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

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
