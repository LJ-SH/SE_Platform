class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_i18n_locale

  def access_denied(exception)
    redirect_to admin_organizations_path, alert: exception.message
  end

  def set_i18n_locale
    # priority setting params[:locale] > session[:locale] > I18n.default_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale 
    unless session[:locale].nil?
      session[:locale] = I18n.locale
    end   
    if params[:locale] && !(I18n.available_locales.include?(params[:locale].to_sym))
      logger.error flash.now[:notice]
      flash.now[:notice] = "#{params[:locale]} translation not available"
    end
  end

  # the step is documented in https://github.com/activeadmin/activeadmin/wiki/Switching-locale
  # BUT it seems that the setting does NOT work for active_admin tabbed-menu since 0.6.0 version!!
  #def default_url_options(options={})
  #  { :locale => I18n.locale }
  #end  

  def after_sign_in_path_for(resource_or_scope)
    session[:locale] = I18n.locale
    stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)
  end

  def access_denied(exception)
    logger.info exception.message
    redirect_to admin_root_path, :alert => exception.message
  end

end
