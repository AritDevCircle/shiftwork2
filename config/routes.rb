Rails.application.routes.draw do
  # match '*unmatched', to: 'application#render_not_found', via: :all

  root 'users#welcome'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users, only: [:new, :create, :show, :update, :edit]
  resources :organizations, only: [:new, :create, :show, :edit, :update]
end
