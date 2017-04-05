require 'feature_spec_helper'

feature 'Change attached files', %q{
  In order to update given information
  As an author of a question
  I want to remove attached files and attach new
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  background do
      sign_in(user)
      visit question_path(question)
      within '.button-bar' do
        click_on 'Edit'
      end
  end

  scenario 'Author of question removes attachment', js: true do
    within '.question' do
      expect(page).to have_link 'pic2.jpg', href: /uploads\/attachment\/file\/\d\/pic2\.jpg/

      within '.nested-fields' do
        first('.attachment-remove').click
      end
      click_on 'Update question'
      wait_for_ajax

      expect(page).to_not have_link 'pic2.jpg', href: /uploads\/attachment\/file\/\d\/pic2\.jpg/
    end
  end

  scenario 'Author of question attach additional file', js: true do
    within '.question' do
      click_on ' Add file'
      first('input[type="file"]').set "#{Rails.root}/spec/files/pic1.jpg"
      click_on 'Update question'
      wait_for_ajax

      expect(page).to have_link 'pic2.jpg', href: /uploads\/attachment\/file\/\d\/pic2\.jpg/
      expect(page).to have_link 'pic1.jpg', href: /uploads\/attachment\/file\/\d\/pic1\.jpg/
    end
  end
end