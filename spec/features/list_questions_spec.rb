require 'rails_helper'

feature 'List questions', %q{
  In order to find interesting content
  As a user
  I want to view questions list
} do

  given!(:questions) { create_list(:question, 5) }

  scenari 'User views the list of questions' do
    visit questions_path
    expect(page).to have_selector '.questions-list'

    questions_list = find '.questions-list'
    questions.each do |q|
        expect(questions_list).to have_link q.title
        expect(questions_list).to have_content q.body
      end
  end
end