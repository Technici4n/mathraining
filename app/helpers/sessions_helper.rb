#encoding: utf-8
module SessionsHelper
  def sign_in(user)
    if !@remember_me.nil? && @remember_me != 0
      cookies.permanent[:remember_token] = user.remember_token
    else
      cookies[:remember_token] =  user.remember_token
    end
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if @current_user.nil?
      @current_user = User.find_by_remember_token(cookies[:remember_token])
      if !@current_user.nil?
        mtn = DateTime.now.in_time_zone.to_date
        if mtn != @current_user.last_connexion
          @current_user.last_connexion = mtn
          @current_user.save
          total = Visitor.where(:date => mtn).first
          if total.nil?
            total = Visitor.new
            total.date = mtn
            total.number_user = 0
            total.number_admin = 0
            if @current_user.admin?
              total.number_admin = total.number_admin+1
            else
              total.number_user = total.number_user+1
            end
            total.save
          else
            if @current_user.admin?
              total.number_admin = total.number_admin+1
            else
              total.number_user = total.number_user+1
            end
            total.save
          end
        end
      end
    end
    return @current_user
  end

  def signed_in_user
    unless signed_in?
      redirect_to root_path, danger: "Vous devez être connecté."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
end
