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
          get '/:id/schedules', to: 'channels#channel_shows'
      end
    end

    resources :schedules,  only: [:index, :show ]
#
  #  resources :terms,  only: [:index, :show ]
    get '/terms', to: "terms#get_term"

    resources :events,   only: [:index, :show ]

    resources :shows,   only: [:index, :show ] do
      collection  do
        get '/live', to: 'shows#shows_live'
      end
    end

    resources :subscriptions, except: [:new, :edit] do
      collection do
        get 'status'

        post 'authorize'
        post 'payment'
        delete 'cancel'
        post 'sync' 
      end
    end

    resources :countries, except: [:new, :edit]

    resources :reminders, only: [:index, :create, :destroy]
  end
end
