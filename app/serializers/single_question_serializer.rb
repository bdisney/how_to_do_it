class SingleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id
  has_many :attachments
  has_many :comments
  has_many :answers
end