class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:show]
  before_action :set_question, only: [:index, :create]
  
  authorize_resource
  
  def index
    respond_with @question.answers
  end
  
  def show
    respond_with @answer, serializer: SingleAnswerSerializer
  end

  def create
    respond_with @question.answers.create(answer_params.merge(user: @current_resource_owner))
  end
  
  private
  
  def set_answer
    @answer = Answer.find(params[:id])
  end
  
  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end