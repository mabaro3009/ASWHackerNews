Rails.application.routes.draw do

  resources :upvotes do
  delete 'destroy', :on => :collection
  end
  resources :posts do
	resources :comments
  end
  resources :comments do
	resources :comments
  end
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'posts#index'

  post "/posts/:id" => "posts#upvote"
  get "/newest" => "posts#newest"
  get "/ask" => "posts#ask"
  get "/reply" => "comments#reply"
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout/', to: 'sessions#logout'

end
