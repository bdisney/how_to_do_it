class Comment < ApplicationRecord
  default_scope { order(:created_at) }

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  after_create_commit { CommentsBroadcastJob.perform_later self }

  def root_question_id
    if commentable_type == 'Question'
      commentable_id
    elsif commentable_type == 'Answer'
      commentable.question_id
    end
  end
end