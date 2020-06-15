class HomeController < ApplicationController

  before_action :forbid_login_user, {only: [:top, :user_create, :user_login]}

  def top
    @user = User.new
    
  end

  def menu
    if @current_user
      records = Record.where(user_id: @current_user.id).order(date: :desc)
      @record_month = []
      year = (Time.new.year).to_s                 # "2020"
      month = (Time.new.month).to_s               # "5"
      if month.length == 1 then
        zero_month = "0" + month.to_s             # "05"
      end
      current_month = year + zero_month           # "202005"

      records.each do |record|
        flag = 1
        target_month = (record.date.to_s)[0, 6] # "202005", "202006"
        for month in @record_month do
          if target_month == month
            flag = 0
          end
        end
        if target_month == current_month
          flag = 0
        end

        if flag == 1
          @record_month.push(target_month)
        end
      end
    else
      # 未ログイン状態
    end

    # secret-box
    data_arrays = Proverb.all
    n = data_arrays.count
    i = rand(1000)%n
    @secret_item = data_arrays[i]
    
  end

  def user_create
    @user = User.new
    if params[:new_name]
      @user.name = params[:new_name]
    else
      @user.name = "名無し" #使えない
    end
    @user.gender = (1 - params[:EClist][:male].to_i)*params[:EClist][:female].to_i
    @user.password = params[:new_password]
    if @user.save
      #flash[:notice] = "ユーザー登録が完了しました" #なぜか効かない...
      session[:user_id] = @user.id
      redirect_to("/records/#{@target}")
    else
      #@error_message = "ユーザ名またはパスワードが間違っています"  #renderが使えないから意味なし
      redirect_to("/menu")
    end
  end

  def user_login
    @user = User.find_by(name: params[:login_name], password: params[:login_password])
    if @user
      session[:user_id] = @user.id
      redirect_to("/records/#{@target}")
    else
      #@error_message = "ユーザ名またはパスワードが間違っています"  #renderが使えないから意味なし
      redirect_to("/menu")
    end
  end

  def user_logout
    session[:user_id] = nil
    #flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def inquiry
    @inquiry = Inquiry.new
    @inquiry.content = params[:content]
    if @inquiry.save
      redirect_to("/")
    end
  end
end
