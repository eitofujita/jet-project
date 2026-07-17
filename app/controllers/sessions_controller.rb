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
      redirect_to destination, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, notice: "ログアウトしました", status: :see_other
  end
end
