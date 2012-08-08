class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_for_subdomain

  def check_for_subdomain
    if request.subdomain.nil? && user_signed_in?
      if current_user.account.present?
        redirect_to root_url :subdomain => current_user.account.name unless current_user.account.name.nil?
      end
    end
  end
end
