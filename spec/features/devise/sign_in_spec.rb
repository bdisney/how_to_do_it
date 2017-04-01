require 'rails_helper'

feature 'User sign in', %q{
  In order to ask a question
  As a registered user
  I want to sign in
} do

  given(:user) { create(:user) }

  background do
    visit root_path
    within('.navbar') { click_on 'Log In' }
  end

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'unknown@test.com'
    fill_in 'Password', with: '12345678'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end