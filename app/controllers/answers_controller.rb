class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: :create
  before_action :set_question
  before_action :check_answer_author, only: [:update, :destroy]
  before_action :check_question_author, only: :set_best
  before_action :build_answer, only: :create
  after_action :publish_answer, only: :create

  include Voted

  respond_to :js

  def set_best
    respond_with(@answer.make_best)
  end

  def create
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  private

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json if @answer.valid?
  end

  def build_answer
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

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
