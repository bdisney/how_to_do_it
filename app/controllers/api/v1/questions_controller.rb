class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show]

  authorize_resource

  def index
    respond_with Question.all
  end

  def show
    respond_with @question, serializer: SingleQuestionSerializer
  end

  def create
    respond_with @current_resource_owner.questions.create(question_params)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end