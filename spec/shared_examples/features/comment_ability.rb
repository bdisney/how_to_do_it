shared_examples_for 'add comment ability' do
  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit commentable_path
    end
  
    scenario 'can see "add comment" link' do
      within commentable_container do
        expect(page).to have_link 'Add comment'
      end
    end

    scenario 'can add comment to record with valid attributes', js: true do
      within commentable_container do
        click_on 'Add comment'
  
        fill_in 'Your comment:', with: 'Comment body'
        click_on 'Add comment'
  
        within '.comments-list' do
          expect(page).to have_content 'Comment body'
        end
      end
    end

    scenario 'can not add comment with empty body', js: true do
      within commentable_container do
        click_on 'Add comment'
  
        fill_in 'Your comment:', with: ''
        click_on 'Add comment'
  
        within '.alert-danger' do
          expect(page).to have_content 'Errors prohibited this record from being saved:'
          expect(page).to have_content 'Body can\'t be blank'
        end
      end
    end
  end

  describe 'All users' do
    scenario 'can see new comments in real-time', js: true do
      Capybara.using_session('author') do
        sign_in(user)
        visit commentable_path
      end

      Capybara.using_session('guest') do
        visit commentable_path
      end

      Capybara.using_session('author') do
        within commentable_container do
          click_on 'Add comment'

          fill_in 'Your comment', with: 'Comment body'
          click_on 'Add comment'

          within '.comments-list' do
            expect(page).to have_content 'Comment body'
          end
        end
      end

      Capybara.using_session('guest') do
        within commentable_container do
          expect(page).to have_content 'Comment body'
        end
      end
    end
  end

  scenario 'Non-authenticated user can not add comment' do
    visit commentable_path
    within commentable_container do
      expect(page).to_not have_link 'Add comment'
    end
  end
end

shared_examples_for 'remove comment ability' do
  describe 'Author of comment' do
    scenario 'see remove comment link'

    scenario 'can remove it'
  end

  scenario 'Another authenticated user do not see remove link'

  scenario 'Non-authenticated user do not see remove link'
end

