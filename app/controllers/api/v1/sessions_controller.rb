class Api::V1::SessionsController < ApiController
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      render json: { message: "ログイン成功", user: user }, status: :ok
    else
      flash.now[:alert] = "ユーザー名またはパスワードが間違っています"
      render json: { error: "ユーザー名またはパスワードが間違っています" }, status: :unauthorized
    end
  end
end
