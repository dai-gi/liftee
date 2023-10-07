class Api::V1::CompanyController < ApiController
  before_action :set_company, only: [:show]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    company = Company.all
    render json: company
  end

  def show
    render json: @company
  end

  private

    def set_company
      @company = Company.find(params[:id])
    end
end