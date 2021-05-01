Rails.application.routes.draw do
  get 'errors/page_not_found'
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
if Rails.env.production?
  get '404', :to => 'application#page_not_found'
  end