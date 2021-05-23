Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/internal_server_error'
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  # match '/404', to: 'application#render_not_found', via: :all

  root 'users#index'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users, only: %i[new create show update edit]
  resources :organizations, only: %i[new create show edit update]
  resources :shifts do
    member do
      patch :take, :drop
      put :take, :drop
    end
  end
  resources :workers
end
