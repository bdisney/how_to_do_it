require 'feature_spec_helper'

feature 'Add comment to answer', %q{
  In order to clarify the answer
  As an authenticated user
  I want to add comments
} do
  given(:user)      { create(:user) }
  given(:question)  { create(:question) }

  it_should_behave_like 'add comment ability' do
    let(:commentable) { create(:answer, question: question) }
    let!(:commentable_path) { question_path(question) }
    let!(:commentable_container) { ".answer[data-answer-id='#{commentable.id}']" }
  end
end