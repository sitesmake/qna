module QuestionsHelper
  def subscription_text(question)
    if current_user.subscribed_for?(question)
      "отписаться от уведомлений"
    else
      "подписаться на уведомления"
    end
  end
end
