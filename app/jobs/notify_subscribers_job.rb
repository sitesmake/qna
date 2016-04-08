class NotifySubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(question, answer)
    question.subscriptions.find_each do |subscr|
      DailyMailer.notify(subscr.user, question, answer).deliver_later
    end
  end
end
