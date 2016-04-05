class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # helper :daiku
  # include DaikuHelper
  # helper Daiku::Application.helpers

  # helper Daiku::DaikuHelper
  # helper Daiku::Engine.helpers
end
