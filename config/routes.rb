Rails.application.routes.draw do
  get 'messages/index'
  get 'messages/show'
  get 'messages/create'

  devise_for :users
  resources :papers
  resources :chats, only: [:create, :show] do
    resources :messages, only: [:create]
  end
  post 'ai_request', to: 'papers#ai_request'

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "papers#index"
end
