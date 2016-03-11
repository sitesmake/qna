require_relative '../acceptance_helper'

feature 'Vote for answer', %q{
  In order to vote for answer
  An an user
  I'd like to vote for answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Non-author' do
	  before do
	    sign_in user
	    visit question_path(question)
	  end

	  scenario 'Can voting up', js: true do
	  	within ".answer-#{answer.id}" do
		    click_on 'vote up'
		    expect(page).to have_content 'rating: 1'
		    expect(page).to_not have_link 'vote up'
      end
      expect(page).to have_content 'voted up'
	  end

	  scenario 'Can voting down', js: true do
  		within ".answer-#{answer.id}" do
		    click_on 'vote down'
		    expect(page).to have_content 'rating: -1'
		    expect(page).to_not have_link 'vote down'
		  end
		  expect(page).to have_content 'voted down'
	  end

	  scenario 'Can cancel vote', js: true do
			within ".answer-#{answer.id}" do
		    click_on 'vote up'
		    expect(page).to_not have_link 'vote up'
		    click_on 'cancel vote'
		    expect(page).to have_content 'rating: 0'
		    expect(page).to have_link 'vote up'
		  end
	  end
	end

  scenario 'Author can not vote' do
    sign_in answer.user
    visit question_path(question)
		within ".answer-#{answer.id}" do
      expect(page).to_not have_link 'vote up'
    end
  end

  scenario 'Non-authenticated user can not vote' do
  	visit question_path(question)
    expect(page).to_not have_link 'vote up'
  end
end
