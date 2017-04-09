class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
	protected
	
	def current_player
		@current_player ||= Player.find_by_
	end
end
