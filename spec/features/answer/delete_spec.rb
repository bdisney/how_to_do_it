require 'rails_helper'

feature 'Author can delete answers', %q{
  In order to hide my wrong answer
  As an author
  I want to have an ability to delete it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  background do
      @delete_link = "a[data-answer-id=\"#{answer.id}\"]"
    end

  scenario 'Author of answer deletes it' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_selector @delete_link
    find(@delete_link).click

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_selector @delete_link
  end

  scenario 'User tries to delete answer of another user' do
    sign_in(user)
    someones_answer = create(:answer, question: question, user: create(:user))
    visit question_path(question)

    expect(page).to_not have_selector "a[data-answer-id=\"#{someones_answer.id}\"]"
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_selector @delete_link
  end
end