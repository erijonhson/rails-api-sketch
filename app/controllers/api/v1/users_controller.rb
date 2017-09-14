class Api::V1::UsersController < ApplicationController
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
      render json: { erros: user.errors }, status: :unprocessable_entity
    end
  end

  def update
    begin
      user = User.find(params[:id])
      if user.update(user_params)
        render json: user, status: :ok
      else
        render json: { erros: user.errors }, status: :unprocessable_entity
      end
    rescue
      head :not_found
    end
  end

  def destroy
    begin
      user = User.find(params[:id])
      user.destroy
      head :no_content
    rescue
      head :not_found
    end
  end

  private

  def user_params 
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
