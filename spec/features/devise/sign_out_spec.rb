require 'feature_spec_helper'

feature 'User sign out', %q{
  In order to destroy my session
  As an authenticated user
  I want to sign out
} do

  scenario 'Authenticated user try to sign out' do
    sign_in(create(:user))
    within('.navbar') { click_on 'Log Out' }

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end