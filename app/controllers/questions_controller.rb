class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :check_user, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    if current_user
      @answer = @question.answers.build(user: current_user)
      @attachment = @answer.attachments.build
    end
    @answers = @question.answers

  end

  def new
    @question = current_user.questions.new
    @attachment = @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your Question was successfully created'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def check_user
    unless current_user.author_of?(@question)
      head(:forbidden)
    end
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
