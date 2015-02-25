require 'sidekiq/web'

class AdminConstraint
  def matches?(request)
    current_user = User.find_by_id(request.session[:user_id])
    current_user.present? && current_user.admin?
  end
end

Rails.application.routes.draw do
  get 'search/find'

  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  use_doorkeeper
  get 'oauths/oauth'
  get 'oauths/callback'
  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback' # for use with Github, Facebook
  get 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

  get '/users/email', to: 'users#email'
  patch '/users/submit_email', to: 'users#submit_email'

  get 'signup' => 'users#new', :as => :signup
  get 'signin' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  get 'search' => 'search#find', :as => :search

  resources :tags, only: [:index, :show]

  concern :votable do
    patch :upvote, on: :member
    patch :downvote, on: :member
  end

  resources :users, concerns: :votable do
    member do
      get :activate
    end
  end
  resources :user_sessions, only: [:new, :create, :destroy]

  root 'questions#index'

  concern :commentable do
    resources :comments, only: [:show, :create, :update, :destroy], concerns: :votable, shallow: true
  end

  resources :questions, concerns: [:commentable, :votable] do
    resources :answers, only: [:index, :edit, :update, :create, :destroy], concerns: [:commentable, :votable], shallow: true do
      patch 'mark', on: :member
    end
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only:[:index, :show, :create], shallow: true do
        resources :answers, only:[:index, :show, :create]
      end
    end
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

