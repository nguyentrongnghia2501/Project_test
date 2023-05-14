class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :set_default_status, only: %i[ create edit destroy ]
  before_action :authenticate_user!


  # GET /posts or /posts.json
  def index
    @posts = Post.where(status: nil).or(Post.where(user_id: current_user.id))
    render json: @posts

  end

  # GET /posts/1 or /posts/1.json
  def show
    render json: @post
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create

    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        render json: @post, status: :created, location: @post
      else
         render json: @post.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.user == current_user && @post.update(post_params)
        render json: @post, status: :ok, location: @post
      else
        render json: { error: "You don't have permission to edit this post." }, status: :unprocessable_entity

      end
    end   
  end 
  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :status, :image).merge(user_id: current_user.id)
    end
    def set_default_status
      self.status ||= nil 
    end
end
