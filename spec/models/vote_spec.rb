require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

  describe 'validate uniqueness of vote' do
    subject { create(:vote) }

    it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]) }
  end

  describe 'validate non-involvement' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    subject { build(:vote, votable: question) }

    it { should_not allow_value(user.id).for(:user_id).with_message('You are not allowed to vote for your Question') }
  end
end