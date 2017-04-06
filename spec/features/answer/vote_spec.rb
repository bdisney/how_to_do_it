require 'feature_spec_helper'

feature 'Vote answer', %q{
  In order to show that the answer was helpful (or not)
  As an authenticated user
  I want to vote for it
} do
  given(:user)      { create(:user) }
  given(:question)  { create(:question) }

  it_should_behave_like 'vote ability' do
    let(:votable) { create(:answer, question: question) }
    let!(:votable_path) { question_path(question) }
    let!(:votable_container) { ".answer[data-answer-id='#{votable.id}']" }
  end
end