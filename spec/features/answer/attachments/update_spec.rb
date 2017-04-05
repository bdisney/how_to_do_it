require 'feature_spec_helper'

feature 'Change answer attachments', %q{
  In order to update given information
  As an author of an answer
  I want to remove attached files and attach new
} do

  given(:user) { create(:user) }
  given(:question) {create(:question)}
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  background do
      sign_in(user)
      visit question_path(question)
      within '.answers-list' do
        click_on 'Edit'
      end
  end

  scenario 'Author of answer removes attachment', js: true do
    within '.answer' do
      expect(page).to have_link 'pic2.jpg', href: /uploads\/attachment\/file\/\d\/pic2\.jpg/

      within '.nested-fields' do
        first('.attachment-remove').click
      end
      click_on 'Update answer'
      wait_for_ajax

      expect(page).to_not have_link 'pic2.jpg', href: /uploads\/attachment\/file\/\d\/pic2\.jpg/
    end
  end

  scenario 'Author of answer attach additional file', js: true do
    within '.answer' do
      click_on ' Add file'
      first('input[type="file"]').set "#{Rails.root}/spec/files/pic1.jpg"
      click_on 'Update answer'
      wait_for_ajax

      expect(page).to have_link 'pic2.jpg', href: /uploads\/attachment\/file\/\d\/pic2\.jpg/
      expect(page).to have_link 'pic1.jpg', href: /uploads\/attachment\/file\/\d\/pic1\.jpg/
    end
  end
end