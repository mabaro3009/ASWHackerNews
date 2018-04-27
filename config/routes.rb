Rails.application.routes.draw do
  resources :comments
	get '/auth/:provider/callback', to: 'sessions#create'
  resources :posts
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'
  
  post "/posts/:id" => "posts#upvote"
  get "/newest" => "posts#newest"
  get "/ask" => "posts#ask"
end
