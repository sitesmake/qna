class AnswersController < ApplicationController
  before_action :load_answer, only: [:edit, :update, :destroy]

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

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question, notice: 'Your Answer was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end
