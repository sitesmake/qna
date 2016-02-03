class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :load_answer, only: [:edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  #def new
  #  @answer = @question.answers.new
  #  @answer.user = current_user
  #end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @question, notice: 'Your Answer was successfully created' }
        format.js
      else
        format.html do
          flash[:alert] = @answer.errors.full_messages
          redirect_to @question
        end
        format.js { @errors = @answer.errors.full_messages }
        #render :new
      end
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to @question, notice: 'Your Answer was successfully updated'
    else
      render :edit
    end
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
