require_relative '../acceptance_helper'
include ActiveJob::TestHelper

feature 'User can subscribe for question new answers', %q{
  In order to read notifications
  As an user
  I want to toggle my subscriptions
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario "User can subscribe", js: true do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_link("отписаться от уведомлений")
    click_on "подписаться на уведомления"

    wait_for_ajax

    expect(page).to have_link("отписаться от уведомлений")
    expect(page).to_not have_link("подписаться на уведомления")
  end

  scenario "User can unsubscribe", js: true do
    sign_in(question.user)

    visit question_path(question)

    expect(page).to_not have_link("подписаться на уведомления")
    click_on "отписаться от уведомлений"

    wait_for_ajax

    expect(page).to_not have_link("отписаться от уведомлений")
    expect(page).to have_link("подписаться на уведомления")
  end

  scenario "Guest can not subscribe" do
    visit question_path(question)

    expect(page).to_not have_content("подписаться на уведомления")
  end

  scenario "User gets notification email", js: true do

    other_user = create(:user)

    sign_in(other_user)

    visit question_path(question)

      fill_in 'Answer', with: 'Use Rails!'

    perform_enqueued_jobs do
      click_on 'Post answer'
      wait_for_ajax
    end

      open_email question.user.email

    expect(current_email).to have_content("Use Rails!")
  end
end
