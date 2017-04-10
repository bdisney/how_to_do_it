class Answer < ApplicationRecord
  include Votable
  include Commentable

  default_scope { order(accepted: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable

  validates :body, presence: true, length: { minimum: 5 }
  validates :accepted, uniqueness: { scope: :question_id }, if: :accepted

  after_create_commit { AnswersBroadcastJob.perform_later self }

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].blank? },
                                allow_destroy: true

  scope :accepted, -> { where(accepted: true) }

  def accept
    transaction do
      question.answers.accepted.update_all(accepted: false)
      toggle(:accepted).save!
    end
  end
end
