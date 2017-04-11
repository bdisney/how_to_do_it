require 'feature_spec_helper'

feature 'Remove questions comment', %q{
  In order to hide useless comment to question
  As an author of comment
  I want to remove it
} do
  given(:user)      { create(:user) }
  given(:question)  { create(:question) }

  it_should_behave_like 'remove comment ability' do
    let(:commentable) { question }
    let!(:commentable_path) { question_path(question) }
    let!(:commentable_container) { '.question' }
  end
end