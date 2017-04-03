require 'feature_spec_helper'

feature 'View question with answers', %q{
  In order to find out solution of a problem
  As a user
  I want to view question with its answers
} do

  scenario 'User view question page without answers' do
    question = create(:question)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'There is no answers yet.'
  end

  scenario 'User view question page with answers' do
    question = create(:question_with_answers)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    within '.answers-list' do
      question.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end
end