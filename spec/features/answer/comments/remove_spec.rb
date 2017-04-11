require 'feature_spec_helper'

feature 'Remove answers comment', %q{
  In order to hide useless comment to answer
  As an author of comment
  I want to remove it
} do
  given(:user)      { create(:user) }
  given(:question)  { create(:question) }

  it_should_behave_like 'remove comment ability' do
    let(:commentable) { create(:answer, question: question) }
    let!(:commentable_path) { question_path(question) }
    let!(:commentable_container) { ".answer[data-answer-id='#{commentable.id}']" }
  end
end