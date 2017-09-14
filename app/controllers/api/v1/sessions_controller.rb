class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: sessions_params[:email])

    if user && user.valid_password?(sessions_params[:password])
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: :ok
    else
      render json: { errors: 'Invalid password or email' }, status: :unauthorized
    end
  end

  def destroy
    begin
      user = User.find_by(auth_token: params[:id])
      user.generate_authentication_token!
      user.save
    rescue
      head :not_found
    end
  end

  private

  def sessions_params
    params.require(:session).permit(:email, :password)
  end
end