class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 10, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }
end
