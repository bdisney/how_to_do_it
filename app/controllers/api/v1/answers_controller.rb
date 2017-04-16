class Api::V1::AnswersController < Api::V1::BaseController
  before_action :get_answer, only: [:show]
  before_action :get_question, only: [:index]
  
  authorize_resource
  
  def index
    respond_with @question.answers
  end
  
  def show
    respond_with @answer, serializer: SingleAnswerSerializer
  end
  
  private
  
  def get_answer
    @answer = Answer.find(params[:id])
  end
  
  def get_question
    @question = Question.find(params[:question_id])
  end
end