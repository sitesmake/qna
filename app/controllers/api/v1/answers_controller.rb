class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]

  def index
    respond_with(@question.answers)
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
    respond_with @answer
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
