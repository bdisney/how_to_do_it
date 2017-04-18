require 'feature_spec_helper'

feature 'Attach files to answer', %q{
  In order to give more information
  As an author of a answer
  I want to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  it_should_behave_like 'add attachments ability' do
    let(:path) { question_path(question) }
    let(:container) { '.answers-list' }
    let(:btn) { 'Add answer' }

    def fill_form
      data = attributes_for(:answer)
      fill_in 'Add your answer:', with: data[:body]
    end
  end
end