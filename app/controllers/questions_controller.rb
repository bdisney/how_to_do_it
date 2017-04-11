class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  before_action :store_user_id, only: :show
  before_action :check_authority, only: [:edit, :update, :destroy]

  respond_to :html
  respond_to :js, only: [:edit, :update]

  def index
    respond_with(@questions = Question.includes(:user))
  end

  def new
    respond_with(@question = Question.new)
  end

  def show
    respond_with(@question)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.new
  end

  def store_user_id
    gon.push({ current_user_id: current_user.id }) if user_signed_in?
  end

  def check_authority
    redirect_to questions_path, alert: 'Permission denied!' unless current_user.author_of?(@question)
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end