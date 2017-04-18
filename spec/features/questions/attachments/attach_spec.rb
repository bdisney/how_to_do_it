require 'feature_spec_helper'

feature 'Attach files to question', %q{
  In order to give more information about my problem
  As an author of a question
  I want to attach files
} do

  given(:user) { create(:user) }

  it_should_behave_like 'add attachments ability' do
    let(:path) { new_question_path }
    let(:container) { '.question' }
    let(:btn) { 'Add question' }

    def fill_form
      data = attributes_for(:question)
      fill_in 'Title', with: data[:title]
      fill_in 'Body', with: data[:body]
    end
  end
end