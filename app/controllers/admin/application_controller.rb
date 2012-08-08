class Admin::ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_admin_permissions!

  def check_admin_permissions!
    authenticate_user!
    unless current_user.admin?
      redirect_to '/'
    end
  end
end
