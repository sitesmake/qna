class AnswersController < ApplicationController
  def new
    @answer = Answer.new(question_id: params[:question_id])
  end

  def create
    @answer = Answer.create(answer_params)
    @answer.question_id = params[:question_id]

    if @answer.save
      redirect_to @answer.question, notice: 'Your Answer was successfully created'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end
