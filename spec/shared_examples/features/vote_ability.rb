shared_examples_for 'vote ability' do
  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit votable_path
    end

    scenario 'can see vote links' do
      within votable_container do
        expect(page).to have_selector '.vote-up'
        expect(page).to have_selector '.vote-down'
        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'can vote up for others answer', js: true do
      within votable_container do
        find('.vote-up').click
        wait_for_ajax
        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'can cancel his vote (if click twice)', js: true do
      within votable_container do
        2.times do
          find('.vote-up').click
          wait_for_ajax
        end
        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'can vote opposite', js: true do
      within votable_container do
        find('.vote-up').click
        wait_for_ajax
  
        find('.vote-down').click
        wait_for_ajax
  
        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  scenario 'Author of record does not see vote links' do
    sign_in(votable.user)
    visit votable_path

    within votable_container do
      expect(page).to_not have_selector '.vote-up'
      expect(page).to_not have_selector '.vote-down'
    end
  end

  scenario 'Non-authenticated user does not see vote links' do
    visit votable_path

    within votable_container do
      expect(page).to_not have_selector '.vote-up'
      expect(page).to_not have_selector '.vote-down'
    end
  end
end 