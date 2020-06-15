class ApplicationController < ActionController::Base

  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authenticate_user
    if @current_user == nil
      #flash[:notice] = "ログインが必要です"
      redirect_to("/")
    end
  end

  def forbid_login_user
    if @current_user
      #flash[:notice] = "既にログインしています"
      @year = Time.new.year                        # 2020
      @month = Time.new.month                      # 5
      @month_s = Time.new.month.to_s               # "5"
      if @month_s.length == 1 then
        @zero_month = "0" + @month.to_s            # "05"
      end
      @target = @year.to_s + @zero_month           # "202005"
      redirect_to("/records/#{@target}")
    end
  end

  @notice = "test"

end
