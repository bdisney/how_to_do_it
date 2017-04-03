require 'feature_spec_helper'

feature 'Create answer', %q{
  In order to help another user
  As an authenticated user
  I want to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer with proper data', js: true do
    sign_in(user)
    visit question_path(question)

    data = attributes_for(:answer)
    fill_in 'Add your answer:', with: data[:body]
    click_on 'Add answer'

    within '.answers-list' do
      expect(page).to have_content data[:body]
    end

    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to create answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)

    data = attributes_for(:invalid_answer)
    fill_in 'Add your answer:', with: data[:body]
    click_on 'Add answer'

    within '.alert-danger' do
      expect(page).to have_content 'Errors prohibited this record from being saved:'
      expect(page).to have_content 'Body can\'t be blank'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)

    expect(page).to_not have_selector '#new_answer'
  end
end
