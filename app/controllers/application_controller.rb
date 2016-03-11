class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  include UserAuthentication

  before_action :set_jbuilder_defaults

  protected

  def authenticate
    token_str = params[:token]
    token = Token.find_by(token: token_str)
    if token.nil? || !token.is_valid? || !@my_app.is_your_token?(token)
      error!('Tu token es inválido', :unauthorized)
    else
      @current_user = token.user
    end
  end

  def authenticate_owner(owner)
    if owner != @current_user
      error!("No estas autorizado para ejecutar ésta acción", :unauthorized )
    end
  end

  def set_jbuilder_defaults
    @errors = []
  end

  def error! message, status
    @errors << message
    response.status = status
    render "api/v1/errors"
  end

  def error_array! array, status
    @errors = @errors + array
    response.status = status
    render "api/v1/errors"
  end
end
