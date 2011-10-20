class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  private
    # Overwriting the sign_in redirect path method
  def after_sign_in_path_for(resource_or_scope)
    user_path(resource_or_scope)
  end

end
