class Api::V1::SheetController < ApiController
  before_action :set_sheet, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    sheet = Sheet.all
    render json: sheet
  end

  def create
    sheet = Sheet.new(sheet_params)
    if sheet.save
      render json: sheet, status: :created
    else
      render json: { errors: sheet.errors.full_messages }
    end
  end

  def show
    render json: @sheet
  end

  def update
    if @sheet.update(sheet_params)
      head :no_content
    else
      render json: { errors: @sheet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @sheet.destroy!
    head :no_content
  end

  private

    def set_sheet
      @sheet = Sheet.find(params[:id])
    end

    def sheet_params
      params.require(:sheet).permit(:name, :project_id)
    end
end
