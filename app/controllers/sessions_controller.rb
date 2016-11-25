class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login user
      redirect_to admin
    else
      flash.now[:error] = 'Invalid email/password'
      render 'new'
    end
  end
  
  def destroy
    
  end
end
