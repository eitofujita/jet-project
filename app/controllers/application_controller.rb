class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :signed_in?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  def require_authentication
    return if signed_in?

    session[:return_to] = request.fullpath if request.request_method.in?(%w[GET HEAD])
    redirect_to login_path, alert: "Пожалуйста, войдите в аккаунт"
  end

  def user_not_authorized
    redirect_back fallback_location: root_path, alert: "У вас нет прав для выполнения этого действия"
  end
end
