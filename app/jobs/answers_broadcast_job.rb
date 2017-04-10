class AnswersBroadcastJob < ApplicationJob
  queue_as :default

  def perform(answer)
    ActionCable.server.broadcast("answers_to_#{answer.question_id}", answer: render_json(answer))
  end

  private

  def render_json(answer)
    ApplicationController.render(partial: 'answers/answer', formats: :json, locals: { answer: answer })
  end
end