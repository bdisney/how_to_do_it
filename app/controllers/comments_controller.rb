class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:destroy]
  before_action :get_commentable, only: [:new, :create]
  before_action :check_authority, only: [:destroy]
  
  def new
    @comment = @commentable.comments.new
  end
  
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def destroy
    @comment.destroy
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def set_comment
    @comment = Comment.find(params[:id])
  end
  
  def get_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
    end
    
    render status: :unprocessable_entity unless @commentable
  end
  
  def check_authority
    render status: :forbidden unless current_user.author_of?(@comment)
  end
end