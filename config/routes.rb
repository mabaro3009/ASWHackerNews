Rails.application.routes.draw do

  ##provisional
  def add_swagger_route http_method, path, opts = {}
    full_path = path.gsub(/{(.*?)}/, ':\1')
    match full_path, to: "#{opts.fetch(:controller_name)}##{opts[:action_name]}", via: http_method
  end

  add_swagger_route 'GET', '/api/posts', controller_name: 'posts', action_name: 'api_post'
  add_swagger_route 'POST', '/api/comments', controller_name: 'comments', action_name: 'api_create_comment'
  add_swagger_route 'POST', '/api/reply', controller_name: 'comments', action_name: 'api_create_reply'
  add_swagger_route 'DELETE', '/api/deleteComment', controller_name: 'comments', action_name: 'api_delete_comment'
  add_swagger_route 'GET', '/api/ask', controller_name: 'posts', action_name: 'api_ask'
  add_swagger_route 'POST', '/api/posts', controller_name: 'posts', action_name: 'api_create_post'
  add_swagger_route 'DELETE', '/api/posts', controller_name: 'posts', action_name: 'api_delete_post'
  add_swagger_route 'POST', 'api/upvote', controller_name: 'upvotes', action_name: 'api_upvote'
  add_swagger_route 'DELETE', 'api/upvote', controller_name: 'upvotes', action_name: 'api_unvote'
  add_swagger_route 'POST', 'api/upvotecomment', controller_name: 'upvotes', action_name: 'api_upvote_comment'
  add_swagger_route 'DELETE', 'api/upvotecomment', controller_name: 'upvotes', action_name: 'api_unvote_comment'
  add_swagger_route 'GET', '/api/posts/:id', controller_name: 'posts', action_name: 'api_post_find_by_id'
  add_swagger_route 'GET', '/api/users/:id', controller_name: 'users', action_name: 'api_get_user'
  #add_swagger_route 'GET', '/api/users', controller_name: 'users', action_name: 'api_post_user  '
  add_swagger_route 'GET', '/api/newest', controller_name: 'posts', action_name: 'api_newest'
  add_swagger_route 'GET', '/api/threads/:id', controller_name: 'comments', action_name: 'api_threads'
  add_swagger_route 'PUT', '/api/users', controller_name: 'users', action_name: 'api_edit_user'
  add_swagger_route 'GET', '/api/userByToken/:token', controller_name: 'users', action_name: 'api_get_user_by_token'
  add_swagger_route 'GET', '/api/posts/upvote/user/:id', controller_name: 'upvotes', action_name: 'api_get_post_by_vote'
  add_swagger_route 'GET', '/api/comments/upvote/:user_id', controller_name: 'upvotes', action_name: 'api_get_comments_by_vote'
  add_swagger_route 'GET', '/api/comments/:id', controller_name: 'comments', action_name: 'api_get_comment'
  add_swagger_route 'GET', '/api/comments/post/:post_id', controller_name: 'comments', action_name: 'api_get_comment_from_post'
  add_swagger_route 'GET', '/api/posts/user/:user_id', controller_name: 'posts', action_name: 'api_get_posts_by_user'
  add_swagger_route 'GET', '/api/replies/:id', controller_name: 'comments', action_name: 'api_get_replies_from_parentComment'
  add_swagger_route 'GET', '/api/upvotes/:post_id', controller_name: 'upvotes', action_name: 'api_is_upvoted'
  add_swagger_route 'GET', '/api/upvotecomment/:comment_id', controller_name: 'upvotes', action_name: 'api_comment_is_upvoted'
  #provisional




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
  get "/threads" => "comments#threads"




end
