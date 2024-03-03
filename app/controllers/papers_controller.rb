require 'pdf-reader'

class PapersController < ApplicationController
  before_action :authenticate_user!
  rescue_from PDF::Reader::MalformedPDFError, with: :handle_invalid_pdf

  def create
    uploaded_io = params[:paper][:pdf]

    if uploaded_io.content_type == 'application/pdf'
      reader = PDF::Reader.new(uploaded_io.tempfile.path)

      title = reader.info[:Title]
      author = reader.info[:Author]

      @paper = current_user.papers.build(paper_params.merge(title: title, author: author))

      if @paper.save
        flash[:success] = "Paper successfully created!"
        redirect_to papers_path
      else
        #flash.now[:error] = "Error creating paper: #{@paper.errors.full_messages.join(', ')}"
        handle_form_error
      end

    else
      flash.now[:error] = "File must be a PDF"
      handle_form_error
    end
  end

  def index
    @papers = current_user.papers
    @paper = Paper.new
  end

  def destroy
    @paper = Paper.find(params[:id])
    @paper.destroy
    redirect_to papers_path, status: :see_other
  end

  def show
    @paper = Paper.find(params[:id])
  end

  private

  def paper_params
    params.require(:paper).permit(:pdf, :title, :author)
  end

  def handle_form_error
    @papers = Paper.all
    render :index, status: :unprocessable_entity
  end

  def handle_invalid_pdf
    flash.now[:alert] = 'Uploaded file is not a valid PDF'
    handle_form_error
  end
end
