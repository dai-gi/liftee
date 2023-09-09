class Api::V1::TaskController < ApplicationController
  before_action :set_task, only: [:show]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    task = Task.all
    render json: task
  end

  def show
    render json: @task
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end
end
