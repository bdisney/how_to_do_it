class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  has_many :votes, dependent: :destroy, as: :votable
  belongs_to :user
  
  validates :title, presence: true, length: { minimum: 10, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].blank? },
                                allow_destroy: true
end
