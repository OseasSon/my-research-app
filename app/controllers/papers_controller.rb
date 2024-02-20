class PapersController < ApplicationController
  before_action :authenticate_user!

  def create
    @paper = current_user.papers.build(paper_params)

    if @paper.save
      flash[:notice] = "Paper successfully created!"
      redirect_to papers_path, notice: 'Paper was successfully created.'
    else
      flash[:alert] = "Error creating paper: #{@paper.errors.full_messages.join(', ')}"
      render :index
    end
  end

  def index
    @papers = Paper.all
    @paper = Paper.new
  end

  private

  def paper_params
    params.require(:paper).permit(:title, :pdf)
  end
end
