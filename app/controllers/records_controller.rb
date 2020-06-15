class RecordsController < ApplicationController
  before_action :forbid_login_user, {only: [:top]}
  before_action :authenticate_user

  def top
    # なぜかログイン後に "/records" にとんでしまうため
  end

  def index
    @target = params[:month]                     # "202005"
    @target_start = (@target + "01").to_i        # 20200501
    @target_end = (@target + "31").to_i          # 20200531

    @target_year_i = @target[0, 4].to_i          # 2020
    @target_month_i = @target[4, 2].to_i         # 5

    case @target_month_i
      when 1
        @prev = (@target_year_i - 1).to_s + "12"   # "201912" 
        @next = @target[0, 4] + "02"               # "202002"
      when 2
        @prev = @target[0, 4] + "01"               # "202001" 
        @next = @target[0, 4] + "03"               # "202002"
      when 3
        @prev = @target[0, 4] + "02"               # "202002" 
        @next = @target[0, 4] + "04"               # "202004"
      when 4
        @prev = @target[0, 4] + "03"               # "202003" 
        @next = @target[0, 4] + "05"               # "202005"
      when 5
        @prev = @target[0, 4] + "04"               # "202004" 
        @next = @target[0, 4] + "06"               # "202006"
      when 6
        @prev = @target[0, 4] + "05"               # "202005" 
        @next = @target[0, 4] + "07"               # "202007"
      when 7
        @prev = @target[0, 4] + "06"               # "202006" 
        @next = @target[0, 4] + "08"               # "202008"
      when 8
        @prev = @target[0, 4] + "07"               # "202007" 
        @next = @target[0, 4] + "09"               # "202009"
      when 9
        @prev = @target[0, 4] + "08"               # "202008" 
        @next = @target[0, 4] + "10"               # "202010"
      when 10
        @prev = @target[0, 4] + "09"               # "202009" 
        @next = @target[0, 4] + "11"               # "202011"
      when 11
        @prev = @target[0, 4] + "10"               # "202010" 
        @next = @target[0, 4] + "12"               # "202012"
      when 12
        @prev = @target[0, 4] + "11"               # "202011" 
        @next = (@target_year_i + 1).to_s + "01"   # "202101"
    end

    @records = Record.where(user_id: @current_user.id).where(date: @target_start..@target_end).order(date: :asc)
    @day = Time.new.day.to_s
    if @day.length == 1 then
      @day = "0" + @day            # "05"
    end
    
  end

  def submit
    @record = Record.new(comment: params[:comment], user_id: @current_user.id, date: params[:date].to_i)
    @error_date = params[:date]
    @error_comment = params[:comment]
    @target = params[:month].to_s
    
    if @current_user.gender == 0 then
      #fx
      if params[:fx][:zero].to_i == 1 then
        @fx = 0
      elsif params[:fx][:one].to_i == 1 then
        @fx = 1
      elsif params[:fx][:two].to_i == 1 then
        @fx = 2
      elsif params[:fx][:three].to_i == 1 then
        @fx = 3
      elsif params[:fx][:four].to_i == 1 then
        @fx = 4
      elsif params[:fx][:five].to_i == 1 then
        @fx = 5
      else
        @fx = -1
      end
      #ph
      if params[:ph][:zero].to_i == 1 then
        @ph = 0
      elsif params[:ph][:one].to_i == 1 then
        @ph = 1
      elsif params[:ph][:two].to_i == 1 then
        @ph = 2
      elsif params[:ph][:three].to_i == 1 then
        @ph = 3
      elsif params[:ph][:four].to_i == 1 then
        @ph = 4
      elsif params[:ph][:five].to_i == 1 then
        @ph = 5
      else
        @ph = -1
      end
      #sr
      if params[:sr][:zero].to_i == 1 then
        @sr = 0
      elsif params[:sr][:one].to_i == 1 then
        @sr = 1
      elsif params[:sr][:two].to_i == 1 then
        @sr = 2
      elsif params[:sr][:three].to_i == 1 then
        @sr = 3
      elsif params[:sr][:four].to_i == 1 then
        @sr = 4
      elsif params[:sr][:five].to_i == 1 then
        @sr = 5
      else
        @sr = -1
      end
      #vt
      if params[:vt][:zero].to_i == 1 then
        @vt = 0
      elsif params[:vt][:one].to_i == 1 then
        @vt = 1
      elsif params[:vt][:two].to_i == 1 then
        @vt = 2
      elsif params[:vt][:three].to_i == 1 then
        @vt = 3
      elsif params[:vt][:four].to_i == 1 then
        @vt = 4
      elsif params[:vt][:five].to_i == 1 then
        @vt = 5
      else
        @vt = -1
      end
      #pb
      if params[:pb][:zero].to_i == 1 then
        @pb = 0
      elsif params[:pb][:one].to_i == 1 then
        @pb = 1
      elsif params[:pb][:two].to_i == 1 then
        @pb = 2
      elsif params[:pb][:three].to_i == 1 then
        @pb = 3
      elsif params[:pb][:four].to_i == 1 then
        @pb = 4
      elsif params[:pb][:five].to_i == 1 then
        @pb = 5
      else
        @pb = -1
      end
      #hb
      if params[:hb][:zero].to_i == 1 then
        @hb = 0
      elsif params[:hb][:one].to_i == 1 then
        @hb = 1
      elsif params[:hb][:two].to_i == 1 then
        @hb = 2
      elsif params[:hb][:three].to_i == 1 then
        @hb = 3
      elsif params[:hb][:four].to_i == 1 then
        @hb = 4
      elsif params[:hb][:five].to_i == 1 then
        @hb = 5
      else
        @hb = -1
      end

      @record.fx = @fx.to_s
      @record.ph = @ph.to_s
      @record.sr = @sr.to_s
      @record.vt = @vt.to_s
      @record.pb = @pb.to_s
      @record.hb = @hb.to_s 
    else
      #vt
      if params[:vt][:zero].to_i == 1 then
        @vt = 0
      elsif params[:vt][:one].to_i == 1 then
        @vt = 1
      elsif params[:vt][:two].to_i == 1 then
        @vt = 2
      elsif params[:vt][:three].to_i == 1 then
        @vt = 3
      elsif params[:vt][:four].to_i == 1 then
        @vt = 4
      elsif params[:vt][:five].to_i == 1 then
        @vt = 5
      else
        @vt = -1
      end
      #ub
      if params[:ub][:zero].to_i == 1 then
        @ub = 0
      elsif params[:ub][:one].to_i == 1 then
        @ub = 1
      elsif params[:ub][:two].to_i == 1 then
        @ub = 2
      elsif params[:ub][:three].to_i == 1 then
        @ub = 3
      elsif params[:ub][:four].to_i == 1 then
        @ub = 4
      elsif params[:ub][:five].to_i == 1 then
        @ub = 5
      else
        @ub = -1
      end
      #bb
      if params[:bb][:zero].to_i == 1 then
        @bb = 0
      elsif params[:bb][:one].to_i == 1 then
        @bb = 1
      elsif params[:bb][:two].to_i == 1 then
        @bb = 2
      elsif params[:bb][:three].to_i == 1 then
        @bb = 3
      elsif params[:bb][:four].to_i == 1 then
        @bb = 4
      elsif params[:bb][:five].to_i == 1 then
        @bb = 5
      else
        @bb = -1
      end
      #fx
      if params[:fx][:zero].to_i == 1 then
        @fx = 0
      elsif params[:fx][:one].to_i == 1 then
        @fx = 1
      elsif params[:fx][:two].to_i == 1 then
        @fx = 2
      elsif params[:fx][:three].to_i == 1 then
        @fx = 3
      elsif params[:fx][:four].to_i == 1 then
        @fx = 4
      elsif params[:fx][:five].to_i == 1 then
        @fx = 5
      else
        @fx = -1
      end

      @record.vt = @vt.to_s
      @record.ub = @ub.to_s
      @record.bb = @bb.to_s
      @record.fx = @fx.to_s
    end

    if @record.save
      redirect_to("/records/#{@target}")
    else

    end

  end

  def edit
    @edit_record = Record.find_by(id: params[:id])
    @target = params[:month]                     # "202005"
    @target_start = (@target + "01").to_i        # 20200501
    @target_end = (@target + "31").to_i          # 20200531

    @target_year_i = @target[0, 4].to_i          # 2020
    @target_month_i = @target[4, 2].to_i         # 5

    case @target_month_i
      when 1
        @prev = (@target_year_i - 1).to_s + "12"   # "201912" 
        @next = @target[0, 4] + "02"               # "202002"
      when 2
        @prev = @target[0, 4] + "01"               # "202001" 
        @next = @target[0, 4] + "03"               # "202002"
      when 3
        @prev = @target[0, 4] + "02"               # "202002" 
        @next = @target[0, 4] + "04"               # "202004"
      when 4
        @prev = @target[0, 4] + "03"               # "202003" 
        @next = @target[0, 4] + "05"               # "202005"
      when 5
        @prev = @target[0, 4] + "04"               # "202004" 
        @next = @target[0, 4] + "06"               # "202006"
      when 6
        @prev = @target[0, 4] + "05"               # "202005" 
        @next = @target[0, 4] + "07"               # "202007"
      when 7
        @prev = @target[0, 4] + "06"               # "202006" 
        @next = @target[0, 4] + "08"               # "202008"
      when 8
        @prev = @target[0, 4] + "07"               # "202007" 
        @next = @target[0, 4] + "09"               # "202009"
      when 9
        @prev = @target[0, 4] + "08"               # "202008" 
        @next = @target[0, 4] + "10"               # "202010"
      when 10
        @prev = @target[0, 4] + "09"               # "202009" 
        @next = @target[0, 4] + "11"               # "202011"
      when 11
        @prev = @target[0, 4] + "10"               # "202010" 
        @next = @target[0, 4] + "12"               # "202012"
      when 12
      @prev = @target[0, 4] + "11"               # "202011" 
      @next = (@target_year_i + 1).to_s + "01"   # "202101"
    end

    @records = Record.where(user_id: @current_user.id).where(date: @target_start..@target_end).order(date: :asc)


  end

  def update
    @edit_record = Record.find_by(id: params[:id])
    @edit_record.comment = params[:comment]
    @edit_record.date = params[:date].to_i

    if @current_user.gender == 0 then
      #fx
      if params[:fx][:zero].to_i == 1 then
        @fx = 0
      elsif params[:fx][:one].to_i == 1 then
        @fx = 1
      elsif params[:fx][:two].to_i == 1 then
        @fx = 2
      elsif params[:fx][:three].to_i == 1 then
        @fx = 3
      elsif params[:fx][:four].to_i == 1 then
        @fx = 4
      elsif params[:fx][:five].to_i == 1 then
        @fx = 5
      else
        @fx = -1
      end
      #ph
      if params[:ph][:zero].to_i == 1 then
        @ph = 0
      elsif params[:ph][:one].to_i == 1 then
        @ph = 1
      elsif params[:ph][:two].to_i == 1 then
        @ph = 2
      elsif params[:ph][:three].to_i == 1 then
        @ph = 3
      elsif params[:ph][:four].to_i == 1 then
        @ph = 4
      elsif params[:ph][:five].to_i == 1 then
        @ph = 5
      else
        @ph = -1
      end
      #sr
      if params[:sr][:zero].to_i == 1 then
        @sr = 0
      elsif params[:sr][:one].to_i == 1 then
        @sr = 1
      elsif params[:sr][:two].to_i == 1 then
        @sr = 2
      elsif params[:sr][:three].to_i == 1 then
        @sr = 3
      elsif params[:sr][:four].to_i == 1 then
        @sr = 4
      elsif params[:sr][:five].to_i == 1 then
        @sr = 5
      else
        @sr = -1
      end
      #vt
      if params[:vt][:zero].to_i == 1 then
        @vt = 0
      elsif params[:vt][:one].to_i == 1 then
        @vt = 1
      elsif params[:vt][:two].to_i == 1 then
        @vt = 2
      elsif params[:vt][:three].to_i == 1 then
        @vt = 3
      elsif params[:vt][:four].to_i == 1 then
        @vt = 4
      elsif params[:vt][:five].to_i == 1 then
        @vt = 5
      else
        @vt = -1
      end
      #pb
      if params[:pb][:zero].to_i == 1 then
        @pb = 0
      elsif params[:pb][:one].to_i == 1 then
        @pb = 1
      elsif params[:pb][:two].to_i == 1 then
        @pb = 2
      elsif params[:pb][:three].to_i == 1 then
        @pb = 3
      elsif params[:pb][:four].to_i == 1 then
        @pb = 4
      elsif params[:pb][:five].to_i == 1 then
        @pb = 5
      else
        @pb = -1
      end
      #hb
      if params[:hb][:zero].to_i == 1 then
        @hb = 0
      elsif params[:hb][:one].to_i == 1 then
        @hb = 1
      elsif params[:hb][:two].to_i == 1 then
        @hb = 2
      elsif params[:hb][:three].to_i == 1 then
        @hb = 3
      elsif params[:hb][:four].to_i == 1 then
        @hb = 4
      elsif params[:hb][:five].to_i == 1 then
        @hb = 5
      else
        @hb = -1
      end

      @edit_record.fx = @fx.to_s
      @edit_record.ph = @ph.to_s
      @edit_record.sr = @sr.to_s
      @edit_record.vt = @vt.to_s
      @edit_record.pb = @pb.to_s
      @edit_record.hb = @hb.to_s 
    else
      #vt
      if params[:vt][:zero].to_i == 1 then
        @vt = 0
      elsif params[:vt][:one].to_i == 1 then
        @vt = 1
      elsif params[:vt][:two].to_i == 1 then
        @vt = 2
      elsif params[:vt][:three].to_i == 1 then
        @vt = 3
      elsif params[:vt][:four].to_i == 1 then
        @vt = 4
      elsif params[:vt][:five].to_i == 1 then
        @vt = 5
      else
        @vt = -1
      end
      #ub
      if params[:ub][:zero].to_i == 1 then
        @ub = 0
      elsif params[:ub][:one].to_i == 1 then
        @ub = 1
      elsif params[:ub][:two].to_i == 1 then
        @ub = 2
      elsif params[:ub][:three].to_i == 1 then
        @ub = 3
      elsif params[:ub][:four].to_i == 1 then
        @ub = 4
      elsif params[:ub][:five].to_i == 1 then
        @ub = 5
      else
        @ub = -1
      end
      #bb
      if params[:bb][:zero].to_i == 1 then
        @bb = 0
      elsif params[:bb][:one].to_i == 1 then
        @bb = 1
      elsif params[:bb][:two].to_i == 1 then
        @bb = 2
      elsif params[:bb][:three].to_i == 1 then
        @bb = 3
      elsif params[:bb][:four].to_i == 1 then
        @bb = 4
      elsif params[:bb][:five].to_i == 1 then
        @bb = 5
      else
        @bb = -1
      end
      #fx
      if params[:fx][:zero].to_i == 1 then
        @fx = 0
      elsif params[:fx][:one].to_i == 1 then
        @fx = 1
      elsif params[:fx][:two].to_i == 1 then
        @fx = 2
      elsif params[:fx][:three].to_i == 1 then
        @fx = 3
      elsif params[:fx][:four].to_i == 1 then
        @fx = 4
      elsif params[:fx][:five].to_i == 1 then
        @fx = 5
      else
        @fx = -1
      end

      @edit_record.vt = @vt.to_s
      @edit_record.ub = @ub.to_s
      @edit_record.bb = @bb.to_s
      @edit_record.fx = @fx.to_s
    end


    @target = params[:month]
    @edit_record.save
    redirect_to("/records/#{@target}")
  end

  def destroy
    @destroy_record = Record.find_by(id: params[:id])
    @destroy_record.destroy
    @target = params[:month]
    redirect_to("/records/#{@target}")
  end
end
