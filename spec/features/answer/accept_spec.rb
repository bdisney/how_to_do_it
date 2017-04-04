require 'feature_spec_helper'

feature 'Accept answer', %q{
  In order to show that answer helped to solve my problem
  As an author of question
  I want to have an ability to accept it
} do

  given(:user) { create(:user) }
  given(:owner) { create(:user) }
  given(:question) { create(:question_with_answers, user: owner) }

  describe 'Author of question did not accept any answer yet' do
    before do
        sign_in(owner)
        visit question_path(question)
    end

    scenario 'can see the accept-links for all answers' do
      within '.answers-list' do
        question.answers.each do |answer|
            within ".answer[data-answer-id='#{answer.id}']" do
              expect(page).to have_selector '.answer-accept'
            end
        end
      end
    end

    scenario 'can accept answer', js: true do
      to_accept = question.answers.sample
      within ".answer[data-answer-id='#{to_accept.id}']" do
        find('.answer-accept').click
        wait_for_ajax

        expect(page).to have_selector '.accepted-on'
        expect(page).to_not have_selector '.accepted-off'
      end
    end
  end

  describe 'Author of question already accepted some answer' do
    before do
      @accepted, @to_accept = question.answers.sample(2)
      @accepted.update(accepted: true)
      sign_in(owner)
      visit question_path(question)
    end

    scenario 'can change his choice and accept another answer', js: true do
      within ".answer[data-answer-id='#{@to_accept.id}']" do
        find('.answer-accept').click
        wait_for_ajax

        expect(page).to have_selector '.accepted-on'
        expect(page).to_not have_selector '.accepted-off'
      end

      within ".answer[data-answer-id='#{@accepted.id}']" do
        expect(page).to have_selector '.accepted-off'
        expect(page).to_not have_selector '.accepted-on'
      end
    end

    scenario 'always see accepted answer on the top', js: true do
      expect(first('.answer')).to have_content @accepted.body

      within ".answer[data-answer-id='#{@to_accept.id}']" do
        find('.answer-accept').click
        wait_for_ajax
      end

      expect(first('.answer')).to have_content @to_accept.body
    end
  end

  scenario 'Another authenticated user does not see links' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_selector '.answer-accept'
  end

  scenario 'Non-authenticated user does not see links' do
    visit question_path(question)

    expect(page).to_not have_selector '.answer-accept'
  end
end
