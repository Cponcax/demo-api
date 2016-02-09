require 'restrictions'

Rails.application.routes.draw do

  apipie
  use_doorkeeper do
    # it accepts :authorizations, :tokens, :applications and :authorized_applications
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  devise_for :users, :skip => [:sessions]

  scope module: :v1, constraints: Restrictions.new(version: 1, default: true), defaults: { format: 'json'} do
    resources :users, only: [:create] do
      collection do
        get 'me',    to: 'users#me'
        put 'me',    to: 'users#update'
        delete 'me', to: 'users#destroy'
      end
    end

    resources :countries, except: [:new, :edit]

    resources :channels
    resources :schedules


    resources :events
    resources :shows, except: [:new, :edit]
  end

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
