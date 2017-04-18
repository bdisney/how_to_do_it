require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_should_behave_like 'broadcastable'

  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should validate_presence_of :body }

  describe '#root_question_id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let!(:comment_to_question) { create(:comment, commentable: question) }
    let!(:comment_to_answer) { create(:comment, commentable: answer) }

    it 'returns id of question' do
      expect(comment_to_question.root_question_id).to eq(question.id)
      expect(comment_to_answer.root_question_id).to eq(question.id)
    end
  end
end