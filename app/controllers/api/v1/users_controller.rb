class Api::V1::UsersController < Api::V1::BaseController

  before_action :authenticate_with_token!, only: [:show, :update, :destroy]
  respond_to :json

  def show
    begin
      user = User.find(params[:id])
      respond_with user
    rescue
      head :not_found 
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private

  def user_params 
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
