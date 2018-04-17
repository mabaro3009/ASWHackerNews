class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
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
  @post = Post.new(post_params)
	@post.user_id = 1;
	@post.votes = 0;
    respond_to do |format|
	  if (!@post.text?) && (!@post.url?)
        format.html { redirect_to @post, notice: 'Either fill in URL or Text.' } 
        format.json { render json: @post.errors, status: :unprocessable_entity }
	  elsif (@post.text?) && (@post.url?)
        format.html { redirect_to @post, notice: 'Either fill in URL or Text.' } 
        format.json { render json: @post.errors, status: :unprocessable_entity }
      elsif @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    puts 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
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
    puts 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
    @post.destroy
    puts 'asdfasdfhjasdfladsfhdslfkjhasdlkfjhsaldkjfhsalkjdfhasldjfkhalskj'
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
    puts 'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc'
	@post = Post.find(params[:id])
	@post.votes = @post.votes + 1
  puts @post.votes
  puts 'ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd'


  
	respond_to do |format|
  if @post.update(post_par2)      
		format.html { redirect_to @post, notice: 'Post was successfully upvoted.' }
		format.json { render :show, status: :ok, location: @post }
  end
	end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :url, :text, :votes)
    end

    def post_par2
     params.permit(:title, :url, :text, :votes)
    end

end
