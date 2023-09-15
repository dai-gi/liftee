class Api::V1::TaskController < ApplicationController
  protect_from_forgery

  before_action :set_task, only: [:show, :update]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    task = Task.all
    render json: task
  end

  def create
    task = Task.new(task_params)
    if task.save
      render json: task, status: :created
    else
      errors = task.errors.full_messages
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: @task
  end

  def update
    if @task.update(task_params)
      head :no_content
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:trader_name, :name, :work_place, :start_datetime, :end_datetime, :vehicles, :notes, :status, :sheet_id)
    end
end
