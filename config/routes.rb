Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'pages#home'

  devise_for  :users, 
              :path => '', 
              :path_names => {:sign_in => 'login', :sign_out => 'logout', :edit => 'profile'},
              :controllers => {:omniauth_callbacks => 'omniauth_callbacks', :registrations => "registrations" }


  resources :users, only: [:show]
  resources :rooms
  resources :photos
  resources :breakdowns
  
  resources :rooms do
    resources :reservations, only: [:create] do
      member do
        post :approve
        post :reject
        post :complete
      end
    end
  end

  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create ]
  end

  resources :rooms do
    resources :reviews, only: [:create, :destroy]
    member do
      post :get_house_rules
    end
  end

  resources :places, only:[] do
    collection do
      post :get_place
    end
  end

  get '/preload' => 'reservations#preload'
  get '/preview' => 'reservations#preview'
  get 'how_it_works' => 'pages#how_it_works'

  get '/trips_history' => 'reservations#trips_history'
  get '/received_reservations' => 'reservations#received_reservations'
  post '/notify' => 'reservations#notify'
  post '/trips_history' => 'reservations#trips_history'
  get '/search' =>'pages#search'
  post '/send_us_email' => 'pages#send_us_email'
  get '/host_earning' => 'pages#host_earning'
  get '/display_listings' => 'pages#display_listings'
  get '/partners' => 'pages#partners'
  mount ActionCable.server, at: '/cable'
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
