module SessionsHelper

  def current_user?(user)
    user == current_user
  end

  def deny_access
    store_location
    redirect_to new_user_session_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
end
