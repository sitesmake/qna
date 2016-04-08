class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user, questions)
    @user = user
    @questions = questions

    mail to: user.email, subject: "Вопросы за прошедший день"
  end

  def notify(user, question, answer)
    @answer = answer

    mail to: user.email, subject: "Новый ответ на вопрос: #{question.title}"
  end
end
