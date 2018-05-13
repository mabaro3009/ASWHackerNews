class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  before_action :authenticate, only: [:api_create_comment, :api_create_reply, :api_delete_comment, :api_threads]
  #before_action :find_post


  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  def threads
    @comments = Comment.order(:created_at).reverse_order.all
	@user = (User.where(:name => params[:user])).first
	#puts @user.name
    @comments = @comments.where(:user_id => @user.id)
  end


  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
        if(params[:comment][:tipus] == 'comment')
      		@post = Post.find(params[:post_id])
      		@comment = @post.comments.create(params[:comment].permit(:text, :tipus))
      	else
      		@parent = Comment.find(params[:comment][:parent_id])
      		#@comment = @parent.replies.create(params[:comment].permit(:text, :tipus, :parent_id))
      		@comment = Comment.new(comment_params)
      		@parent.replies << @comment
      		@comment.tipus = 'reply'
      		@comment.post_id = @parent.post.id
      	end
      	@comment.user_id = current_user.id

      	@comment.save

      	if @comment.save
      		if @comment.tipus == 'comment'
      			redirect_to post_path(@post)
      		else
      			redirect_to post_path(@parent.post)
      		end
      	else
      		render 'new'
      	end
  end

  def add_reply
	@parent = Comment.find(params[:parent])
	@comment = @parent.replies.add_reply(params[:comment].permit(:text))
	@comment.user_id = current_user.id
	@comment.post_id = @parent.post.id
	@comment.tipus = 'reply'
	@comment.parent_id = @parent.id
	@comment.save

	if @comment.save
		redirect_to post_path(@comment.post)
	else
		render 'new'
	end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, 	ºlocation: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.post, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  ##API CALLS

  def api_create_comment
    @comment = Comment.new({text: params['comment']})
    @comment.user_id = @api_user.id
    @comment.post_id = params[:post_id]
    @comment.tipus = 'comment'
    @comment.save
    if @comment.save
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :bad_request
    end
  end


  def api_create_reply
    @comment = Comment.new({text: params['comment']})
    @comment.parent_id = params[:parent_id]
    @comment.user_id = @api_user.id
    @comment.post_id = params[:post_id]
    @comment.tipus = 'reply'
    @comment.save
    if @comment.save
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :bad_request
    end
  end

  def api_delete_comment
    @comment = Comment.find(params[:id])
	if @comment.user_id == @api_user.id
    #@comment.destroy
		if @comment.destroy
		render json: @comment, status: :ok
		else
		render json: @comment.errors, status: :bad_request
		end
	else
		render json: {:error => 'Unauthorized'}.to_json, :status => 401
	end
  end
  
  def api_threads
	@user = User.find(params[:id])
	@comments = Comment.order(:created_at).reverse_order.all
    @comments = @comments.where(:user_id => @user.id)
	render json: @comments, status: :ok
  end
  
  ##end API CALLS

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:text, :user_id, :votes, :parent_id)
    end
    
	def find_post
		@post = Post.find(params[:post_id])
	end
end
