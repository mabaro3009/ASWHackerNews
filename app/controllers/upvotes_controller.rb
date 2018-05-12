class UpvotesController < ApplicationController
  #before_action :set_upvote, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:api_upvote, :api_unvote]

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
#aixo no se si es aixi salu2
    #@post = Post.find(params[:post_id])
    if Upvote.where(:post_id => params[:post_id]).where(:user_id => @api_user.id).exists? #&& :user_id => @api_user.id)
      render json: {:error => 'Unauthorized'}.to_json, :status => 401
    else
      @upvote = Upvote.new({post_id: params['post_id']})
      @upvote.user_id = @api_user.id


  #aixo esta be
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
      if @upvote[0].destroy
        render json: @upvote, status: :ok
      else
        render json: @upvote.errors, status: :bad_request
      end

    else
      render json: {:error => 'no votat'}.to_json, :status => 404
  end
end







 #   @upvote.destroy
 
#      if @upvote.post_id?













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
