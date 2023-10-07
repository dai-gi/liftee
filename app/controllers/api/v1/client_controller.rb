class Api::V1::ClientController < ApiController
  before_action :set_client, only: [:show]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    client = Client.all
    render json: client
  end

  def show
    render json: @client
  end

  private

    def set_client
      @client = Client.find(params[:id])
    end
end
