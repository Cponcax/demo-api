require 'restrictions'

Rails.application.routes.draw do


  apipie
  use_doorkeeper do
    # it accepts :authorizations, :tokens, :applications and :authorized_applications
    skip_controllers :authorizations, :applications, :authorized_applications

    controllers :tokens => 'oauth/tokens'
  end

  devise_for :users, :skip => [:passwords, :sessions]

  devise_scope :user do
    scope :users do
      post '/password(.:format)',        to: 'v1/passwords#create', as: :user_password
      get  '/password/edit(.:format)',   to: 'v1/passwords#edit',   as: :edit_user_password
      patch '/password(.:format)',       to: 'v1/passwords#update'
      put   '/password(.:format)',       to: 'v1/passwords#update'
    end
  end

  scope module: :v1, constraints: Restrictions.new(version: 1, default: true), defaults: { format: 'json'} do
    resources :users, only: [:create] do
      collection do
        get 'me'

        put 'me',          to: 'users#update'
        delete 'me',       to: 'users#destroy'

        put 'update_password'
      end
    end

    resources :countries,  only: [:index, :show ]

    resources :channels, only: [:index, :show ] do
      collection do
          get '/:id/shows', to: 'channels#channel_shows'
      end
    end

    resources :schedules,  only: [:index, :show ]

    resources :events,   only: [:index, :show ]

    resources :shows,   only: [:index, :show ] do
      collection  do
        get '/live', to: 'shows#shows_live'
      end
    end

    resources :ratings,   only: [:index, :show ]

    resources :countries, except: [:new, :edit]

    resources :reminders, only: [:index, :create, :destroy]
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
