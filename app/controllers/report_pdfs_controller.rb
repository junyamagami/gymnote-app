class ReportPdfsController < ApplicationController
  def index
    @month = params[:month]
    redirect_to("/menu/report/#{@month}/display.pdf")
  end

  def display
    @target_start = (params[:month]).to_s + "01"
    @target_end = (params[:month]).to_s + "31"
    
    #@records = Record.all # pdf上で使用するレコードのインスタンスを作成
    @records = Record.where(user_id: @current_user.id).where(date: @target_start..@target_end).order(date: :asc)
    
    respond_to do |format|
      format.html
      format.pdf do

        # pdfを新規作成。インスタンスを渡す。
        pdf = ReportPdf.new(@records)

        send_data pdf.render,
          filename:    "Gymnote_月間レポート_"+ ((@records[0].date).to_s)[0, 6] + ".pdf",
          type:        "application/pdf"
      end
    end
  end
end
