require 'feature_spec_helper'

feature 'User sign up', %q{
  In order to have an ability to ask questions and add answers
  As non-registered user
  I want to sign up
} do

  background do
    visit root_path
    within('.navbar') { click_on 'Sign Up' }
    expect(current_path).to eq new_user_registration_path
  end

  scenario 'User try to sign up with proper data' do
    data = attributes_for(:user)
    fill_in 'Email', with: data[:email]
    fill_in 'Password', with: data[:password]
    fill_in 'Password confirmation', with: data[:password_confirmation]
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'User try to sign up with invalid data' do
    fill_in 'Email', with: 'unknown@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: ''
    click_button 'Sign up'

    expect(page).to have_content 'Errors prohibited this user from being saved:'
    expect(current_path).to eq user_registration_path
  end

  scenario 'User already has an account (email is taken) and tries to sign up' do
    user = create(:user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_button 'Sign up'

    expect(page).to have_content 'Errors prohibited this user from being saved:'
    expect(current_path).to eq user_registration_path
  end
end