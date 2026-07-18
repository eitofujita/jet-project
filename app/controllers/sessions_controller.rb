class SessionsController < ApplicationController
  def new
    redirect_to root_path if signed_in?
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user&.authenticate(params[:password])
      destination = session.delete(:return_to) || root_path
      reset_session
      session[:user_id] = user.id
      redirect_to destination, notice: "Вы вошли в аккаунт"
    else
      flash.now[:alert] = "Неверная электронная почта или пароль"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Вы вышли из аккаунта", status: :see_other
  end
end
