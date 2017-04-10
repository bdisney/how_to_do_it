class CommentsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    if comment.root_question_id.present?
      ActionCable.server.broadcast("comments_to_#{comment.root_question_id}", comment: render_json(comment))
    end
  end

  private

  def render_json(comment)
    ApplicationController.render(partial: 'comments/comment', formats: :json, locals: { comment: comment })
  end
end