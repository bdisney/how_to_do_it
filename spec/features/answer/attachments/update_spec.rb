require 'feature_spec_helper'

feature 'Change answer attachments', %q{
  In order to update given information
  As an author of an answer
  I want to remove attached files and attach new
} do

  given(:user) { create(:user) }
  given(:question) {create(:question)}
  given(:attachable) { create(:answer, question: question, user: user) }

  it_should_behave_like 'edit attachments ability' do
    let(:path) { question_path(question) }
    let(:trigger_container) { '.answers-list' }
  end
end