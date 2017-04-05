require 'feature_spec_helper'

feature 'Attach files to question', %q{
  In order to give more information about my problem
  As an author of a question
  I want to attach files
} do

  given(:user) { create(:user) }

  background do
      sign_in(user)
      visit new_question_path
    end

  scenario 'Authenticated user creates question with attachments', js: true do
    data = attributes_for(:question)
    fill_in 'Title', with: data[:title]
    fill_in 'Body', with: data[:body]
    first('input[type="file"]').set "#{Rails.root}/spec/files/file_01.txt"
    click_on '+ Add file'
    all('input[type="file"]').last.set "#{Rails.root}/spec/files/file_02.txt"
    click_on 'Add question'

    expect(page).to have_link 'file_01.txt', href: /uploads\/attachment\/file\/\d\/file_01\.txt/
    expect(page).to have_link 'file_02.txt', href: /uploads\/attachment\/file\/\d\/file_02\.txt/
  end
end