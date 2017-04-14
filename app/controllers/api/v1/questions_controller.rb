class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    respond_with(@questions = Question.all)
  end
end