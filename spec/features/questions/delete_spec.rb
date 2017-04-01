require 'rails_helper'

feature 'Author can delete question', %q{
  In order to cancel my question
  As an author
  I want to have an ability to delete it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Author of question deletes it' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_selector '#delete-question-btn'
    find('#delete-question-btn').click

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Question was successfully deleted.'
  end

  scenario 'User tries to delete question of another user' do
    sign_in(user)
    someones_question = create(:question)
    visit question_path(someones_question)

    expect(page).to_not have_selector '#delete-question-btn'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_selector '#delete-question-btn'
  end

end