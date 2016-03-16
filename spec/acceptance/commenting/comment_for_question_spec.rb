require_relative '../acceptance_helper'

feature 'Comment for question', %q{
  In order to add/remove comment for question
  An an user
  I'd like to add/remove comment for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
	  before do
	    sign_in user
	  end

	  scenario 'Can add comment', js: true do
	  	visit question_path(question)
	  	within '#question' do
		    fill_in 'Comment', with: 'ok-comment'
		    click_on 'Post comment'
		    expect(page).to have_content 'ok-comment'
		  end
	  end

    scenario 'Can remove his comments', js: true do
    	comment = create(:comment, user: user, commentable: question)
    	visit question_path(question)
    	within '#question' do
  	    click_on '(remove this comment)'
  	    expect(page).to_not have_content comment.body
  	  end
    end

    scenario 'Can remove others comments', js: true do
    	user2 = create(:user)
    	comment = create(:comment, user: user2, commentable: question)
    	visit question_path(question)
	    expect(page).to_not have_content '(remove this comment)'
    end
	end

  scenario 'Non-authenticated user can not add comments' do
  	visit question_path(question)
    expect(page).to_not have_link 'Post comment'
  end
end
