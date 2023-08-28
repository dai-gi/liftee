class Api::V1::SheetController < ApplicationController
  before_action :set_project, only: [:show]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    sheet = Sheet.all
    render json: sheet
  end

  def show
    render json: @sheet
  end

  private

    def set_project
      @sheet = Sheet.find(params[:id])
    end
end
