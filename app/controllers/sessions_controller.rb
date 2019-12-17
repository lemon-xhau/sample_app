class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        flash[:success] = t ".welcome"
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_to user
      else
        flash[:warning] = t ".not_activate"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".invalid_combine"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
