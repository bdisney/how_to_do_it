require 'feature_spec_helper'

feature 'Attach files to answer', %q{
  In order to give more information
  As an author of a answer
  I want to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
      sign_in(user)
      visit question_path(question)
    end

  scenario 'Authenticated user creates answer with attachments', js: true do
    data = attributes_for(:answer)
    fill_in 'Add your answer:', with: data[:body]
    click_on '+ Add file'
    all('input[type="file"]').first.set "#{Rails.root}/spec/files/file_01.txt"
    click_on '+ Add file'
    all('input[type="file"]').last.set "#{Rails.root}/spec/files/file_02.txt"
    click_on 'Add answer'

    within '.answers-list' do
      expect(page).to have_link 'file_01.txt', href: /uploads\/attachment\/file\/\d\/file_01\.txt/
      expect(page).to have_link 'file_02.txt', href: /uploads\/attachment\/file\/\d\/file_02\.txt/
    end
  end
end