class QuestionsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(question)
    ActionCable.server.broadcast('questions', question: render_question(question))
  end

  private

  def render_question(question)
    ApplicationController.renderer.render(partial: 'questions/question', locals: { question: question })
  end
end