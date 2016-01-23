class AnswersController < ApplicationController
  def new
    @answer = Answer.new(question_id: params[:question_id])
  end
end
