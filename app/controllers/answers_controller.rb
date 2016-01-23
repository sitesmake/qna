class AnswersController < ApplicationController
  before_action :load_answer, only: [:edit]
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

  def edit
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end
