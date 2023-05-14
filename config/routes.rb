Rails.application.routes.draw do
  resources :posts
  devise_for :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener_web" if Rails.env.development?

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
