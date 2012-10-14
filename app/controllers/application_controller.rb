class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  before_filter :check_for_subdomain

  def check_for_subdomain
    if (request.subdomain.empty? || request.subdomain == "www") && user_signed_in?
      if current_user.account
        redirect_to(
          (root_url subdomain: current_user.account.name.parameterize) +
          request.path.sub(/^\//, '')
        )
      end
    end
  end
end
