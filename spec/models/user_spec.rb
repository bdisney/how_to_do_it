require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:nullify) }
  it { should have_many(:answers).dependent(:nullify) }
  
  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
  
    it 'return true if user is author' do
      expect(user).to be_author_of(question)
    end

    it 'returns false if user is not author' do
      expect(user).to_not be_author_of(create(:question))
    end
  end
end
