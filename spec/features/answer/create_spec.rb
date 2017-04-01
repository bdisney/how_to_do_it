require 'rails_helper'

feature 'Create answer', %q{
  In order to help another user
  As an authenticated user
  I want to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer with proper data' do
    sign_in(user)
    visit question_path(question)
    click_on 'Add answer'

    expect(current_path).to eq new_question_answer_path(question)

    data = attributes_for(:answer)
    fill_in 'Body', with: data[:body]
    click_on 'Add answer'

    expect(find '.answers-list').to have_content data[:body]
    expect(page).to have_content 'Answer was successfully added.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to create answer with invalid data' do
    sign_in(user)
    visit question_path(question)
    click_on 'Add answer'

    expect(current_path).to eq new_question_answer_path(question)

    data = attributes_for(:invalid_answer)
    fill_in 'Body', with: data[:body]
    click_on 'Add answer'

    expect(page).to have_content 'Errors prohibited this record from being saved:'
    expect(current_path).to eq question_answers_path(question)
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
    click_on 'Add answer'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
