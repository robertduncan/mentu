class SessionsController < ApplicationController
	include SessionsHelper
	skip_before_action :require_login


	def create
	  # redirect_to events_path and return if current_user
	  auth_hash = request.env['omniauth.auth']
	  auth = Authorization.find_by_uid auth_hash['uid']
	  #redirect to user page if they've already authorized
	  if auth
	    session[:user_id] = auth.user.id
	    redirect_to root_path(sign_in: true) and return
	  else #create new user if not authorized
	    user = User.create_with_facebook auth_hash
	    session[:user_id] = user.id 
	    redirect_to root_path({sign_up: true})
	  end
	end

	def destroy
		current_user.update_attributes active: false;
		session[:user_id] = nil
		redirect_to root_path
	end
end