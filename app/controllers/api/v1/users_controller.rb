class Api::V1::UsersController < ApplicationController
  respond_to :json

  def show
    begin
      user = User.find(params[:id])
      respond_with user
    rescue
      head 404 # not found
    end
  end

  def create
    begin
      user = User.new(user_params)
      if user.save
        render json: user, status: 201 # created
      else
        render json: { erros: user.errors }, status: 422 # unprocessable entity
      end
    rescue
      head 409 # conflict
    end
  end

  def update
    begin
      user = User.find(params[:id])
      if user.update(user_params)
        render json: user, status: 200 # success
      else
        render json: { erros: user.errors }, status: 422 # unprocessable entity
      end
    rescue
      head 409 # conflict
    end
  end
  
  private

  def user_params 
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
