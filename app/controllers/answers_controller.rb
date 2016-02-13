class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, except: [:set_best_answer]
  before_action :load_answer, only: [:edit, :update, :destroy, :set_best_answer]
  before_action :check_user, only: [:edit, :update, :destroy]

  def set_best_answer
    @answer.make_best
    @question = @answer.question
    @answers = @question.answers
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    @answers = @question.answers
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    @answers = @question.answers
  end

  def destroy
    @answer.destroy
    redirect_to @question
  end

  private

  def check_user
    unless current_user.author_of?(@answer)
      redirect_to @question, alert: "Only author allowed to modify answer"
    end
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
