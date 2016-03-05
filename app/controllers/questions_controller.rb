class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy, :vote, :cancel_vote]
  before_action :check_user, only: [:update, :destroy]
  before_action :check_voted, only: [:vote]
  before_action :check_author, only: [:vote]

  def vote
    if params[:points].to_i < 0
      @vote = @question.vote_down(current_user)
      @message = "voted down"
    else
      @vote = @question.vote_up(current_user)
      @message = "voted up"
    end

    render json: { id: @question.id, message: @message, output: render_to_string(partial: 'votes/block', locals: { data: @question }) }
  end

  def cancel_vote
    @vote = @question.votes.where(user: current_user).first
    @vote.destroy
    @message = "vote is cancelled"

    render json: { id: @question.id, message: @message, output: render_to_string(partial: 'votes/block', locals: { data: @question }) }
  end

  def index
    @questions = Question.all
  end

  def show
    if current_user
      @answer = @question.answers.build(user: current_user)
      @attachments = @answer.attachments.build
    end
    @answers = @question.answers

  end

  def new
    @question = current_user.questions.new
    @attachments = @question.attachments.build
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

  def check_author
    if current_user.author_of?(@question)
      head(:forbidden)
    end
  end

  def check_voted
    if current_user.voted_for?(@question)
      head(:forbidden)
    end
  end

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
