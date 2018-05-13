class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:api_create_post, :api_delete_post]

  # GET /posts
  # GET /posts.json
  def index
	@posts = Post.order(sort_column_votes + " " + sort_direction)

	@posts = @posts.tipo("url")
	@contador = 0

  end

  # GET /posts/newest
  # GET /posts.json
  def newest
    @posts = Post.order(:created_at).reverse_order.all
    @contador = 0
  end

  # GET /posts/ask
  # GET /posts.json
  def ask
	@posts = Post.order(sort_column_votes + " " + sort_direction)
	@posts = @posts.tipo("ask")
  @contador = 0

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
	@comments = Comment.where(post_id: @post , tipus: 'comment').order("votes DESC")
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create


    if post_params[:text] == "" and Post.where(:url => post_params[:url]).exists?
      @post_existent = Post.where(:url => post_params[:url])
      @post_2 = @post_existent.first
      redirect_to post_path(@post_2)

    else
  @post = Post.new(post_params)
  @post.user_id = current_user.id;
  @post.upvotes_count = 0;
  if(@post.text?)
      @post.tipo = "ask"
    else
      @post.tipo = "url"
  end


    respond_to do |format|
    if (!@post.text?) && (!@post.url?)
        #flash[:alert] = "Error creating new post!"
        #render :new

        format.html { render :new, notice: 'Post was successfully created.'}
        format.json { render json: @post.errors, status: :unprocessable_entity }
    elsif (@post.text?) && (@post.url?)
        format.html { render :new , notice: 'Post was successfully created.'}
        format.json { render json: @post.errors, status: :unprocessable_entity }
      elsif @post.save
        format.html { redirect_to newest_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    end


  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
	if (!@post.text?) && (!@post.url?)
        format.html { redirect_to @post, notice: 'Either fill in URL or Text.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
	  elsif (@post.text?) && (@post.url?)
        format.html { redirect_to @post, notice: 'Either fill in URL or Text.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      elsif @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }

    end
  end

  def showError
  end

  #POST /posts/:id
  #POST /posts/:id.json
  def upvote
	@post = Post.find(params[:id])
	@post.votes = @post.votes + 1
  puts @post.votes



	respond_to do |format|
  if @post.update(post_par2)
		format.html { redirect_to @post, notice: 'Post was successfully upvoted.' }
		format.json { render :show, status: :ok, location: @post }
  end
	end
  end

  def addComment
  	@post = Post.find(params[:id])
  	@post.nComments = @post.nComments + 1
  	puts @post.nComments

  	respond_to do |format|
  		if @post.update(post_par3)
  			format.html { redirect_to @post }
  			format.json { render :show, status: :ok, location: @post }
  		end
  	end
  end

  ##API CALLS
  def api_post
    @posts = Post.order(sort_column_votes + " " + sort_direction)
    @posts = @posts.tipo("url")
    render json: @posts
  end

  def api_ask
    @posts = Post.order(sort_column_votes + " " + sort_direction)
	@posts = @posts.tipo("ask")
    render json: @posts
  end

  def api_create_post
	if Post.where(:url => params[:content]).exists?
		render json: @post.errors, status: :bad_request
	else
		@post = Post.new({title: params['title']})
		@post.user_id = @api_user.id
		@post.tipo = params[:tipo]
		@post.upvotes_count = 0;

		if @post.tipo == 'url'
			@post.url = params[:content]
		elsif @post.tipo == 'ask'
			@post.text = params[:content]
		else
			render json: @comment.errors, status: :bad_request
		end

		if @post.save
		  render json: @post, status: :ok
		else
		  render json: @post.errors, status: :bad_request
		end
	end
  end

  def api_delete_post
	@post = Post.find(params[:post_id])
	if @post.user_id = @api_user.id
		if @post.destroy
		render json: @post, status: :ok
		else
		render json: @post.errors, status: :bad_request
		end
	else
		render json: {:error => 'Unauthorized'}.to_json, :status => 401
	end
  end
  
  def api_post_find_by_id
	@post = Post.find(params[:id])
	render json: @post
  end
  
  def api_newest
    @posts = Post.order(:created_at).reverse_order.all
    render json: @posts, status: :ok
  end



  ##end API CALLS

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :url, :text, :votes, :content, :tipo)
    end

    def post_par2
     params.permit(:title, :url, :text, :votes)
    end

	def sort_column_votes
		Post.column_names.include?(params[:sort]) ? params[:sort] : "upvotes_count"
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
	end

	



end
