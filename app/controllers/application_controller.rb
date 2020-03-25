require 'csv'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include ActionView::Helpers::NumberHelper
  #@session_time = 15.minutes
  #auto_session_timeout @session_time
  #def session_time
  #  logger.info "Session time action in Application controller.................#{Time.now}"
  #  @session_time = 15.minutes
  #  @session_str = ""
  #
  #end
  #
  rescue_from ActionController::InvalidAuthenticityToken do

    respond_to do |format|
      if request.format.html?
        flash[:danger] = "Sorry, your session has expired. Kindly try again!"
        format.html { redirect_to root_url }
      else
        flash.now[:note] = "Sorry, your session has expired. Kindly try again!!"
        format.js { render '/home/index' }
      end

    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    # redirect_to request.referer
    respond_to do |format|
      if request.format.html?
        flash[:danger] = "Sorry, you're not authorized to perform this action!"
        format.html { redirect_to root_path }
      else
        flash.now[:note] = "Sorry, you're not authorized to perform this action!!"
        format.js { render '/home/index' }
      end

    end

  end

  protected

  def self.permission
    return name = self.name.gsub('Controller', '').singularize.split('::').last.constantize.name rescue nil
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  #load the permissions for the current user so that UI can be manipulated
  def load_permissions
    @current_permissions = current_user.role.permissions.collect { |i| [i.subject_class, i.action] }
  end

  def configure_permitted_parameters
     #devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:user_name, :last_name, :first_name, :contact_number, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:user_name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:user_name, :last_name, :first_name, :contact_number, :entity_code, :division_code, :access_type, :email, :password, :password_confirmation, :current_password) }

  end

end
