class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, optional: true
  
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: [1, -1]
  
  validate :non_involvement
  
  private
  
  def non_involvement
    errors.add(:user_id, "You are not allowed to vote for your #{votable_type}") if votable && user_id == votable.user_id
  end
end