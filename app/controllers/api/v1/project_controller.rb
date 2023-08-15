class Api::V1::ProjectController < ApplicationController
  before_action :set_project, only: [:show]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    project = Project.all
    render json: project
  end

  def show
    render json: @project
  end

  private

    def set_project
      @project = Project.find(params[:id])
    end
end
