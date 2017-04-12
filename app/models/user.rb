class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :identities, dependent: :destroy

  def author_of?(record)
    record.user_id == id
  end

  def self.find_for_oauth(auth)
    identity = Identity.find_or_initialize_by(provider: auth.provider, uid: auth.uid.to_s)
    return identity.user if identity.persisted?
    
    user = User.find_or_initialize_by(email: auth.info[:email])
    transaction do
      unless user.persisted?
        password = Devise::friendly_token(10)
        user.assign_attributes(password: password, password_confirmation: password)
        user.save!
      end
      identity.user = user
      identity.save!
    end
    user
  end
end
