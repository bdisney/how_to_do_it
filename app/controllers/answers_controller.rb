class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:edit, :update, :destroy, :accept]
  before_action :check_authority, only: [:edit, :update, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def edit
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def accept
    return redirect_to @answer.question, alert: 'Permission denied!' unless current_user.author_of?(@answer.question)
    @answer.accept
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def check_authority
    redirect_to @answer.question, alert: 'Permission denied!' unless current_user.author_of?(@answer)
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
