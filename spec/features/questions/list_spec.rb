require 'rails_helper'

feature 'List questions', %q{
  In order to find interesting content
  As a user
  I want to view questions list
} do

  given!(:questions) { create_list(:question, 5) }

  scenario 'User views the list of questions' do
    visit questions_path
    expect(page).to have_selector '.questions-list'

    within '.questions-list' do
      questions.each do |q|
        expect(page).to have_link q.title
        expect(page).to have_content q.body
      end
    end
  end
end