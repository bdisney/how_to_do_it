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
          expect(page).to have_content 'body can\'t be blank'
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

  describe 'Non-authenticated user' do
    scenario 'can not add comment' do
      visit commentable_path
      within commentable_container do
        expect(page).to_not have_link 'Add comment'
      end
    end
  end
end

shared_examples_for 'remove comment ability' do
  let!(:comment) { create(:comment, commentable: commentable, user: user) }

  describe 'Author of comment' do
    before do
      sign_in(user)
      visit commentable_path
    end

    scenario 'can see remove comment link', js: true do
      within commentable_container do
        expect(page).to have_selector '.comment-delete'
      end
    end

    scenario 'can remove it', js: true do
      within commentable_container do
        expect(page).to have_content comment.body

        find('.comment-delete').click
        wait_for_ajax

        expect(page).to_not have_content comment.body
      end
    end
  end

  describe 'Another authenticated user' do
    scenario 'does not see remove link', js: true do
      sign_in(create(:user))
      visit commentable_path
      expect(page).to_not have_selector '.comment-delete'
    end
  end

  describe 'Non-authenticated user' do
    scenario 'does not see remove link', js: true do
      visit commentable_path
      expect(page).to_not have_selector '.comment-delete'
    end
  end
end

