require 'feature_spec_helper'

feature 'Update answer', %q{
  In order to fix my answer
  As an author
  I want to update it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Author of answer' do
    before do
        sign_in(user)
        visit question_path(question)
      end

    scenario 'sees edit link', js: true do
      within '.answers-list' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'updates answer with valid data', js: true do
      within '.answers-list' do
        click_on 'Edit'

        fill_in 'Add your answer:', with: 'Updated answer body'
        click_on 'Update answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Updated answer body'
        expect(page).to_not have_selector 'textarea'
      end
      expect(current_path).to eq question_path(question)
    end

    scenario 'updates answer with invalid data', js: true do
      within '.answers-list' do
        click_on 'Edit'

        fill_in 'Add your answer:', with: ''
        click_on 'Update answer'

        expect(page).to have_content 'Errors prohibited this record from being saved:'
        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to have_selector 'textarea'
      end
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'User tries to updates answer of another user', js: true do
    sign_in(create(:user))
    visit question_path(question)

    within '.answers-list' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Non-authenticated user tries to updates answer' do
    visit question_path(question)
    within '.answers-list' do
      expect(page).to_not have_link 'Edit'
    end
  end
end