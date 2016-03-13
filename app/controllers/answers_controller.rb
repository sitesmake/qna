class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: :create
  before_action :set_question
  before_action :check_answer_author, only: [:update, :destroy]
  before_action :check_question_author, only: :set_best

  include Voted

  def set_best
    @answer.make_best
    @answers = @question.answers
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    @answers = @question.answers

    respond_to do |format|
      if @answer.save
        format.js do
          PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json
        end
      else
        format.js
      end
    end
  end

  def update
    @answer.update(answer_params)
    @answers = @question.answers
  end

  def destroy
    @answer.destroy
  end

  private

  def check_answer_author
    unless current_user.author_of?(@answer)
      head(:forbidden)
    end
  end

  def check_question_author
    unless current_user.author_of?(@question)
      head(:forbidden)
    end
  end

  def set_question
    if params[:question_id]
      @question = Question.find(params[:question_id])
    else
      @question = @answer.question
    end
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
