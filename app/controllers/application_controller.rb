require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.html { redirect_to root_path, alert: e.message }
      format.json { head :forbidden }
      format.js { render json: { error: e.message }, status: :forbidden }
    end
  end

  check_authorization unless: :to_skip?

  def to_skip?
    devise_controller? || is_a?(HighVoltage::PagesController)
  end
end
