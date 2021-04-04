Rails.application.routes.draw do
  # match '*unmatched', to: 'application#render_not_found', via: :all

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
