require 'feature_spec_helper'

feature 'Change attached files', %q{
  In order to update given information
  As an author of a question
  I want to remove attached files and attach new
} do

  given(:user) { create(:user) }
  given(:attachable) { create(:question, user: user) }

  it_should_behave_like 'edit attachments ability' do
    let(:path) { question_path(attachable) }
    let(:trigger_container) { '.button-bar' }
  end
end