class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :get_question, only: [:show]

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question, serializer: SingleQuestionSerializer
  end

  private

  def get_question
    @question = Question.find(params[:id])
  end
end