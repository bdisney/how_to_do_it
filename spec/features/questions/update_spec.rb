require 'feature_spec_helper'

feature 'Update question', %q{
  In order to fix my question
  As an author
  I want to update it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Author of question' do
    before do
        sign_in(user)
        visit question_path(question)
      end

    scenario 'sees edit link', js: true do
      within '.button-bar' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'updates question with valid data', js: true do
      within '.button-bar' do
        click_on 'Edit'
      end

      within '.question' do
        fill_in 'Title', with: 'Updated question title'
        fill_in 'Body', with: 'Updated question body'
        click_on 'Update question'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Updated question title'
        expect(page).to have_content 'Updated question body'
        expect(page).to_not have_selector '.question-form'
      end
    end

    scenario 'updates question with invalid data', js: true do
      within '.button-bar' do
        click_on 'Edit'
      end

      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Update question'

        expect(page).to have_content 'Errors prohibited this record from being saved:'
        expect(page).to have_content 'title can\'t be blank'
        expect(page).to have_content 'body can\'t be blank'
        expect(page).to have_selector '.question-form'
      end
    end

    scenario 'can cancel update', js: true do
      within '.button-bar' do
        click_on 'Edit'
      end

      within '.question' do
        expect(page).to have_button 'Cancel'

        fill_in 'Title', with: 'Updated question title'
        fill_in 'Body', with: 'Updated question body'
        click_on 'Cancel'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to_not have_content 'Updated question title'
        expect(page).to_not have_content 'Updated question body'
        expect(page).to_not have_selector '.question-form'
      end
    end
  end

  scenario 'User tries to update question of another user', js: true do
    sign_in(create(:user))
    visit question_path(question)

    within '.button-bar' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Non-authenticated user tries to update question' do
    visit question_path(question)

    within '.button-bar' do
      expect(page).to_not have_link 'Edit'
    end
  end
end