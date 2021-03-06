class UpvotesController < ApplicationController
  #before_action :set_upvote, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:api_upvote, :api_unvote, :api_upvote_comment, :api_unvote_comment, :api_is_upvoted, :api_comment_is_upvoted]

  # GET /upvotes
  # GET /upvotes.json
  def index
    @upvotes = Upvote.all
  end

  # GET /upvotes/1
  # GET /upvotes/1.json
  def show
  end


  def api_upvote
    if Upvote.where(:post_id => params[:post_id]).where(:user_id => @api_user.id).exists? #&& :user_id => @api_user.id)
      render json: {:error => 'Unauthorized'}.to_json, :status => 401
    else
      @upvote = Upvote.new({post_id: params['post_id']})
      @upvote.user_id = @api_user.id
	  @post = Post.find(@upvote.post_id)
	  @user = User.find(@post.user_id)
      @user.update_attribute(:karma, @user.karma + 1)


      if @upvote.save
        render json: @upvote, status: :ok
      else
        render json: @upvote.errors, status: :bad_request
      end
    end
  end

  def api_unvote
    if Upvote.where(:post_id => params[:post_id]).where(:user_id => @api_user.id).exists?
      @upvote = Upvote.where(:post_id => params[:post_id]).where(:user_id => @api_user.id)
      @post = Post.find(@upvote[0].post_id)
      if @upvote[0].destroy
		    @user = User.find(@post.user_id)
		    @user.update_attribute(:karma, @user.karma - 1)
        render json: @upvote, status: :ok
      else
        render json: @upvote.errors, status: :bad_request
      end
    else
      render json: {:error => 'no votat'}.to_json, :status => 404
  end
end


def api_is_upvoted
  if Upvote.where(:post_id => params[:post_id]).where(:user_id => @api_user.id).exists?
    render :json => "true"
  else
    render :json => "false"
  end
end

def api_comment_is_upvoted
  if Upvote.where(:comment_id => params[:comment_id]).where(:user_id => @api_user.id).exists?
    render :json => "true"
  else
    render :json => "false"
  end
end



def api_upvote_comment
  if Comment.where(:id => params[:comment_id]).exists?
    if Upvote.where(:comment_id => params[:comment_id]).exists?
      render json: @upvote.errors, status: :bad_request
    else
      @upvote = Upvote.new({comment_id: params['comment_id']})
      @upvote.user_id = @api_user.id

	  @comment = Comment.find(@upvote.comment_id)
    @comment.update_attribute(:votes, @comment.votes + 1)
	  @user = User.find(@comment.user_id)
    @user.update_attribute(:karma, @user.karma + 1)

      if @upvote.save
        render json: @upvote, status: :ok
      else
        render json: @upvote.errors, status: :bad_request
      end

    end

  else
    render json: {:error => 'no existeix el comentari'}.to_json, :status => 404
  end

end

def api_unvote_comment
  if Comment.where(:id => params[:comment_id]).exists?
    if Upvote.where(:comment_id => params[:comment_id]).where(:user_id => @api_user.id).exists?
      @upvote = Upvote.where(:comment_id => params[:comment_id]).where(:user_id => @api_user.id)
      @comment = Comment.find(@upvote[0].comment_id)
      @comment.update_attribute(:votes, @comment.votes - 1)
	  @user = User.find(@comment.user_id)
	  if @upvote[0].destroy
		@user.update_attribute(:karma, @user.karma - 1)

        render json: @upvote, status: :ok
      else
        render json: @upvote.errors, status: :bad_request
      end

    else
      #no es del user
      render json: {:error => 'Unauthorized'}.to_json, :status => 401
    end
  else
    #no existeix el commentari
    render json: {:error => 'no existeix el comentari'}.to_json, :status => 404

  end


end

def api_get_post_by_vote

  @upvotes  = Upvote.where(user_id: params[:id] )
  @posts = []
  for @upvote in @upvotes
    if @upvote.comment_id.nil?
    @posts << Post.find(@upvote.post_id)
    end
  end
  render json: @posts, status: :ok
end

def api_get_comments_by_vote

  @upvotes  = Upvote.where(user_id: params[:user_id] )
  @comments = []
  for @upvote in @upvotes
    if @upvote.comment_id?
    @comments << Comment.find(@upvote.comment_id)
    end
  end
  render json: @comments, status: :ok
end






  # GET /upvotes/new
  def new
    @upvote = Upvote.new
  end

  # GET /upvotes/1/edit
  def edit
  end

  # POST /upvotes
  # POST /upvotes.json
  def create
  @upvote = Upvote.new(upvote_params)
  @upvote.user_id = current_user.id
  if @upvote.comment_id?
	@comment = Comment.find(@upvote.comment_id)
    @user = User.find(@comment.user_id)
    @comment.update_attribute(:votes, @comment.votes + 1)
  else
	@post = Post.find(@upvote.post_id)
	@user = User.find(@post.user_id)

  end

  @user.update_attribute(:karma, @user.karma + 1)

    respond_to do |format|
      if @upvote.save
		if @upvote.post_id?
			format.html { redirect_back(fallback_location: root_path) }
		else
			format.html { redirect_to @upvote.comment.post }
		end
        format.json { render :show, status: :created, location: @upvote }
      else
        format.html { render :new }
        format.json { render json: @upvote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /upvotes/1
  # PATCH/PUT /upvotes/1.json
  def update
    respond_to do |format|
      if @upvote.update(upvote_params)

        format.html { redirect_to @upvote, notice: 'Upvote was successfully updated.' }
        format.json { render :show, status: :ok, location: @upvote }
      else
        format.html { render :edit }
        format.json { render json: @upvote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /upvotes/1
  # DELETE /upvotes/1.json
  def destroy
	@upvote = Upvote.find(params[:upvote])
  if @upvote.comment_id?
	@comment = Comment.find(@upvote.comment_id)
    @user = User.find(@comment.user_id)
    @comment.update_attribute(:votes, @comment.votes - 1)
  else
	@post = Post.find(@upvote.post_id)
	@user = User.find(@post.user_id)
  end
  @user.update_attribute(:karma, @user.karma - 1)
    @upvote.destroy
    respond_to do |format|
      if @upvote.post_id?
			format.html { redirect_back(fallback_location: root_path) }
		else
			format.html { redirect_to @upvote.comment.post }
		end
      format.json { head :no_content }
    end
  end

  def delete_vote
	@upvote = Upvote.find(params[:upvote])
    @upvote.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upvote
      @upvote = Upvote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upvote_params
      params.require(:upvote).permit(:user_id, :post_id, :comment_id)
    end
end
