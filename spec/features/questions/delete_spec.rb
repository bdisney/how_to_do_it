require 'feature_spec_helper'

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
    within '.button-bar' do
      expect(page).to have_link 'Delete'
      click_on 'Delete'
    end

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'User tries to delete question of another user' do
    sign_in(user)
    someones_question = create(:question)
    visit question_path(someones_question)

    within '.button-bar' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    within '.button-bar' do
      expect(page).to_not have_link 'Delete'
    end
  end

end