class PapersController < ApplicationController
  before_action :authenticate_user!

  def new
    @paper = Paper.new
  end

  def create
    @paper = current_user.papers.build(paper_params)

    if @paper.save
      redirect_to papers_path, notice: 'Paper was successfully created.'
    else
      render :new
    end
  end

  def index
    @papers = Paper.all
  end

  private

  def paper_params
    params.require(:paper).permit(:title)
  end
end
