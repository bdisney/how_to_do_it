class SingleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id
  has_many :attachments
  has_many :comments
end