require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:nullify) }
  it { should have_many(:answers).dependent(:nullify) }
  
  describe '#author_of?' do
    let(:user) { create(:user) }
  
    it 'return true if user is author' do
        expect(user.author_of?(create(:question, user: user))).to eq true
    end

    it 'returns false if user is not author' do
      expect(user.author_of?(create(:question))).to eq false
    end
  end
end
