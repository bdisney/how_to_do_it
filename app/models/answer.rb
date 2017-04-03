class Answer < ApplicationRecord
  default_scope { order(accepted: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }
  validates :accepted, uniqueness: { scope: :question_id }, if: :accepted

  scope :accepted, -> { where(accepted: true) }

  def accept
    transaction do
      question.answers.accepted.update_all(accepted: false)
      toggle(:accepted).save!
    end
  end
end
