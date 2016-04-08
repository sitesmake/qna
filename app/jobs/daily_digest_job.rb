class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    questions = Question.for_last_day

    User.find_each do |user|
      DailyMailer.digest(user, questions).deliver_later
    end
  end
end
