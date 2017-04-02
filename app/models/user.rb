class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  def author_of?(record)
    record.user_id == id
  end
end
