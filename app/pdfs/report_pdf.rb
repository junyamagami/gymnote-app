
class ReportPdf < Prawn::Document

  # recordにモデルなどのデータを渡します
  def initialize(records)
  
    # superで初期設定を指定します(ページサイズ、マージン等)
    super(
      page_layout: :portrait,
      page_size: 'A4',
      top_margin: 30,
      bottom_margin: 30,
      left_margin: 20,
      right_margin: 20
    )
  
    font 'app/assets/fonts/ipaexm.ttf' # fontをパスで指定

    @records = records # インスタンスを受け取り。コンポーネント作成時などにレコード内のデータを使える
    

    @user_id = @records[0].user_id
    @user = User.find_by(id: @user_id)
    

    if @user.gender == 0
      @date_array = []
      @val_array = []
      @comment_array = []
      @ave_array = [0, 0, 0, 0, 0, 0, 0]
      n = 0

      for record in @records do
        n = n + 1
        day = (((record.date).to_s)[6,2]).to_i
        @date_array.push(day)
        all = ((record.fx).to_i + (record.ph).to_i + (record.sr).to_i + (record.vt).to_i + (record.pb).to_i + (record.hb).to_i) * 100 / 6
        @values_for_ave = [(record.fx).to_i, (record.ph).to_i, (record.sr).to_i, (record.vt).to_i, (record.pb).to_i, (record.hb).to_i, all]
        all = (all.to_s)[0,1] + "." + (all.to_s)[1,2]
        @values = [(record.fx).to_i, (record.ph).to_i, (record.sr).to_i, (record.vt).to_i, (record.pb).to_i, (record.hb).to_i, all]
        @val_array.push(@values)
        @comment_array.push(record.comment)
        for j in 0..6 do
          @ave_array[j] = @ave_array[j] + @values_for_ave[j]
        end
      end

      @ave_array2 = [0, 0, 0, 0, 0, 0, 0]
      for j in 0..6 do
        @ave_array[j] = @ave_array[j] * 100 / n
        @ave_array2[j] = @ave_array[j]
        @ave_array[j] = (@ave_array[j].to_s)[0,1] + "." + (@ave_array[j].to_s)[1,2]
      end


      @first = []
      @second = []
      @third = []

      i = 0
      for d in 1..31 do
        yobi = (Time.new(((@records[0].date).to_s)[0,4], ((@records[0].date).to_s)[4,2], d)).wday
        if yobi == 0
          yobi_s = "日"
        end
        if yobi == 1
          yobi_s = "月"
        end
        if yobi == 2
          yobi_s = "火"
        end
        if yobi == 3
          yobi_s = "水"
        end
        if yobi == 4
          yobi_s = "木"
        end
        if yobi == 5
          yobi_s = "金"
        end
        if yobi == 6
          yobi_s = "土"
        end
        d_s = "#{d}" + "(#{yobi_s})"
        @first.push(d_s)
        if d == @date_array[i]
          @second.push(@val_array[i])
          @third.push(@comment_array[i])
          i = i + 1
        else
          @second.push(["-", "-", "-", "-", "-", "-", "-"])
          @third.push("")
        end
      end

      # 座標を表示
      #stroke_axis

      # 座標を指定して画像を表示する
      image 'app/assets/images/logo2.png', at: [0, 783], width: 120

      # 複雑なテーブルの表示
      rows = [
        [{ content: '月間レポート', rowspan: 2 }, "#{((@records[0].date).to_s)[0,4]}年#{((@records[0].date).to_s)[4,2]}月"],
        ["#{@user.name}　"]
      ]
      # セルの高さ30、左上詰め詰め
      table rows, cell_style: { height: 25, padding: 0 } do
        # 枠線なし
        cells.borders = []
        # 文字サイズ
        cells.size = 10

        columns(0).align = :right
        columns(0).size = 27
        columns(0).width = 370
        columns(0).padding = 5

        columns(1).align = :right
        columns(1).size = 12
        columns(1).width = 185

        columns(1).row(0).padding = 5
        
      end
      
      # 単純なテキストの表示
      if false
        text "#{@date_array[0]}"
        text "#{@val_array[0]}"
        text "#{@comment_array[0]}"
        text "#{@first[0]}"
        text "#{@second[0]}"
        text "#{@third[0]}"
      end
      
      move_down 8
      
      # 複雑なテーブルの表示
      rows = [
        ["日付", "床", "あん馬", "つり輪", "跳馬", "平行棒", "鉄棒", "全体", "コメント"],
        ["#{@first[0]}", "#{@second[0][0]}", "#{@second[0][1]}", "#{@second[0][2]}", "#{@second[0][3]}", "#{@second[0][4]}", "#{@second[0][5]}", "#{@second[0][6]}", "#{@third[0]}"],
        ["#{@first[1]}", "#{@second[1][0]}", "#{@second[1][1]}", "#{@second[1][2]}", "#{@second[1][3]}", "#{@second[1][4]}", "#{@second[1][5]}", "#{@second[1][6]}", "#{@third[1]}"],
        ["#{@first[2]}", "#{@second[2][0]}", "#{@second[2][1]}", "#{@second[2][2]}", "#{@second[2][3]}", "#{@second[2][4]}", "#{@second[2][5]}", "#{@second[2][6]}", "#{@third[2]}"],
        ["#{@first[3]}", "#{@second[3][0]}", "#{@second[3][1]}", "#{@second[3][2]}", "#{@second[3][3]}", "#{@second[3][4]}", "#{@second[3][5]}", "#{@second[3][6]}", "#{@third[3]}"],
        ["#{@first[4]}", "#{@second[4][0]}", "#{@second[4][1]}", "#{@second[4][2]}", "#{@second[4][3]}", "#{@second[4][4]}", "#{@second[4][5]}", "#{@second[4][6]}", "#{@third[4]}"],
        ["#{@first[5]}", "#{@second[5][0]}", "#{@second[5][1]}", "#{@second[5][2]}", "#{@second[5][3]}", "#{@second[5][4]}", "#{@second[5][5]}", "#{@second[5][6]}", "#{@third[5]}"],
        ["#{@first[6]}", "#{@second[6][0]}", "#{@second[6][1]}", "#{@second[6][2]}", "#{@second[6][3]}", "#{@second[6][4]}", "#{@second[6][5]}", "#{@second[6][6]}", "#{@third[6]}"],
        ["#{@first[7]}", "#{@second[7][0]}", "#{@second[7][1]}", "#{@second[7][2]}", "#{@second[7][3]}", "#{@second[7][4]}", "#{@second[7][5]}", "#{@second[7][6]}", "#{@third[7]}"],
        ["#{@first[8]}", "#{@second[8][0]}", "#{@second[8][1]}", "#{@second[8][2]}", "#{@second[8][3]}", "#{@second[8][4]}", "#{@second[8][5]}", "#{@second[8][6]}", "#{@third[8]}"],
        ["#{@first[9]}", "#{@second[9][0]}", "#{@second[9][1]}", "#{@second[9][2]}", "#{@second[9][3]}", "#{@second[9][4]}", "#{@second[9][5]}", "#{@second[9][6]}", "#{@third[9]}"],
        ["#{@first[10]}", "#{@second[10][0]}", "#{@second[10][1]}", "#{@second[10][2]}", "#{@second[10][3]}", "#{@second[10][4]}", "#{@second[10][5]}", "#{@second[10][6]}", "#{@third[10]}"],
        ["#{@first[11]}", "#{@second[11][0]}", "#{@second[11][1]}", "#{@second[11][2]}", "#{@second[11][3]}", "#{@second[11][4]}", "#{@second[11][5]}", "#{@second[11][6]}", "#{@third[11]}"],
        ["#{@first[12]}", "#{@second[12][0]}", "#{@second[12][1]}", "#{@second[12][2]}", "#{@second[12][3]}", "#{@second[12][4]}", "#{@second[12][5]}", "#{@second[12][6]}", "#{@third[12]}"],
        ["#{@first[13]}", "#{@second[13][0]}", "#{@second[13][1]}", "#{@second[13][2]}", "#{@second[13][3]}", "#{@second[13][4]}", "#{@second[13][5]}", "#{@second[13][6]}", "#{@third[13]}"],
        ["#{@first[14]}", "#{@second[14][0]}", "#{@second[14][1]}", "#{@second[14][2]}", "#{@second[14][3]}", "#{@second[14][4]}", "#{@second[14][5]}", "#{@second[14][6]}", "#{@third[14]}"],
        ["#{@first[15]}", "#{@second[15][0]}", "#{@second[15][1]}", "#{@second[15][2]}", "#{@second[15][3]}", "#{@second[15][4]}", "#{@second[15][5]}", "#{@second[15][6]}", "#{@third[15]}"],
        ["#{@first[16]}", "#{@second[16][0]}", "#{@second[16][1]}", "#{@second[16][2]}", "#{@second[16][3]}", "#{@second[16][4]}", "#{@second[16][5]}", "#{@second[16][6]}", "#{@third[16]}"],
        ["#{@first[17]}", "#{@second[17][0]}", "#{@second[17][1]}", "#{@second[17][2]}", "#{@second[17][3]}", "#{@second[17][4]}", "#{@second[17][5]}", "#{@second[17][6]}", "#{@third[17]}"],
        ["#{@first[18]}", "#{@second[18][0]}", "#{@second[18][1]}", "#{@second[18][2]}", "#{@second[18][3]}", "#{@second[18][4]}", "#{@second[18][5]}", "#{@second[18][6]}", "#{@third[18]}"],
        ["#{@first[19]}", "#{@second[19][0]}", "#{@second[19][1]}", "#{@second[19][2]}", "#{@second[19][3]}", "#{@second[19][4]}", "#{@second[19][5]}", "#{@second[19][6]}", "#{@third[19]}"],
        ["#{@first[20]}", "#{@second[20][0]}", "#{@second[20][1]}", "#{@second[20][2]}", "#{@second[20][3]}", "#{@second[20][4]}", "#{@second[20][5]}", "#{@second[20][6]}", "#{@third[20]}"],
        ["#{@first[21]}", "#{@second[21][0]}", "#{@second[21][1]}", "#{@second[21][2]}", "#{@second[21][3]}", "#{@second[21][4]}", "#{@second[21][5]}", "#{@second[21][6]}", "#{@third[21]}"],
        ["#{@first[22]}", "#{@second[22][0]}", "#{@second[22][1]}", "#{@second[22][2]}", "#{@second[22][3]}", "#{@second[22][4]}", "#{@second[22][5]}", "#{@second[22][6]}", "#{@third[22]}"],
        ["#{@first[23]}", "#{@second[23][0]}", "#{@second[23][1]}", "#{@second[23][2]}", "#{@second[23][3]}", "#{@second[23][4]}", "#{@second[23][5]}", "#{@second[23][6]}", "#{@third[23]}"],
        ["#{@first[24]}", "#{@second[24][0]}", "#{@second[24][1]}", "#{@second[24][2]}", "#{@second[24][3]}", "#{@second[24][4]}", "#{@second[24][5]}", "#{@second[24][6]}", "#{@third[24]}"],
        ["#{@first[25]}", "#{@second[25][0]}", "#{@second[25][1]}", "#{@second[25][2]}", "#{@second[25][3]}", "#{@second[25][4]}", "#{@second[25][5]}", "#{@second[25][6]}", "#{@third[25]}"],
        ["#{@first[26]}", "#{@second[26][0]}", "#{@second[26][1]}", "#{@second[26][2]}", "#{@second[26][3]}", "#{@second[26][4]}", "#{@second[26][5]}", "#{@second[26][6]}", "#{@third[26]}"],
        ["#{@first[27]}", "#{@second[27][0]}", "#{@second[27][1]}", "#{@second[27][2]}", "#{@second[27][3]}", "#{@second[27][4]}", "#{@second[27][5]}", "#{@second[27][6]}", "#{@third[27]}"],
        ["#{@first[28]}", "#{@second[28][0]}", "#{@second[28][1]}", "#{@second[28][2]}", "#{@second[28][3]}", "#{@second[28][4]}", "#{@second[28][5]}", "#{@second[28][6]}", "#{@third[28]}"],
        ["#{@first[29]}", "#{@second[29][0]}", "#{@second[29][1]}", "#{@second[29][2]}", "#{@second[29][3]}", "#{@second[29][4]}", "#{@second[29][5]}", "#{@second[29][6]}", "#{@third[29]}"],
        ["#{@first[30]}", "#{@second[30][0]}", "#{@second[30][1]}", "#{@second[30][2]}", "#{@second[30][3]}", "#{@second[30][4]}", "#{@second[30][5]}", "#{@second[30][6]}", "#{@third[30]}"],
        ["平均", "#{@ave_array[0]}", "#{@ave_array[1]}", "#{@ave_array[2]}", "#{@ave_array[3]}", "#{@ave_array[4]}", "#{@ave_array[5]}", "#{@ave_array[6]}", ""]
      ]

      # セルの高さ30、左上詰め詰め
      table rows, cell_style: { height: 15, width: 25, padding: 1 } do
        # 枠線なし
        cells.borders = []
        # 文字サイズ
        cells.size = 10
        # 枠線左と上だけ
        cells.borders = %i[left top right bottom]
        cells.align = :center
        #columns(1).width = 180 # 男子：25*6 + 30, 女子： 35*4 + 30
        
        columns(8).width = 338
        # 1行目の背景色をff7500に
        row(1).background_color = 'EEEEEE'
        row(3).background_color = 'EEEEEE'
        row(5).background_color = 'EEEEEE'
        row(7).background_color = 'EEEEEE'
        row(9).background_color = 'EEEEEE'
        row(11).background_color = 'EEEEEE'
        row(13).background_color = 'EEEEEE'
        row(15).background_color = 'EEEEEE'
        row(17).background_color = 'EEEEEE'
        row(19).background_color = 'EEEEEE'
        row(21).background_color = 'EEEEEE'
        row(23).background_color = 'EEEEEE'
        row(25).background_color = 'EEEEEE'
        row(27).background_color = 'EEEEEE'
        row(29).background_color = 'EEEEEE'
        row(31).background_color = 'EEEEEE'

        row(0).height = 18
        row(0).padding = 3
        row(32).height = 18
        row(32).padding = 3
        columns(0).background_color = 'FFFFFF'
        columns(0).width = 37
        columns(7).width = 30
      end

      move_down 15

      #text "#{@val_array[0][6]}"

      # 座標を指定してテキストを表示する
      #draw_text 'ネコと和解せよ', at: [160, 50], size: 30


      @data = [
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""]
      ]

      @ave_array2[6] = @ave_array2[6] / 100
      
      for j in 0..6 do
        if @ave_array2[j] > 25
          @data[j][9] = "■"
        end
        if @ave_array2[j] > 75
          @data[j][8] = "■"
        end
        if @ave_array2[j] > 125
          @data[j][7] = "■"
        end
        if @ave_array2[j] > 175
          @data[j][6] = "■"
        end
        if @ave_array2[j] > 225
          @data[j][5] = "■"
        end
        if @ave_array2[j] > 275
          @data[j][4] = "■"
        end
        if @ave_array2[j] > 325
          @data[j][3] = "■"
        end
        if @ave_array2[j] > 375
          @data[j][2] = "■"
        end
        if @ave_array2[j] > 425
          @data[j][1] = "■"
        end
        if @ave_array2[j] > 475
          @data[j][0] = "■"
        end
      end

      event_graph = [
        [{content: "　種目別平均グラフ", colspan: 8 }],
        ["5", "#{@data[0][0]}", "#{@data[1][0]}", "#{@data[2][0]}", "#{@data[3][0]}", "#{@data[4][0]}", "#{@data[5][0]}", "#{@data[6][0]}"],
        [" ", "#{@data[0][1]}", "#{@data[1][1]}", "#{@data[2][1]}", "#{@data[3][1]}", "#{@data[4][1]}", "#{@data[5][1]}", "#{@data[6][1]}"],
        ["4", "#{@data[0][2]}", "#{@data[1][2]}", "#{@data[2][2]}", "#{@data[3][2]}", "#{@data[4][2]}", "#{@data[5][2]}", "#{@data[6][2]}"],
        [" ", "#{@data[0][3]}", "#{@data[1][3]}", "#{@data[2][3]}", "#{@data[3][3]}", "#{@data[4][3]}", "#{@data[5][3]}", "#{@data[6][3]}"],
        ["3", "#{@data[0][4]}", "#{@data[1][4]}", "#{@data[2][4]}", "#{@data[3][4]}", "#{@data[4][4]}", "#{@data[5][4]}", "#{@data[6][4]}"],
        [" ", "#{@data[0][5]}", "#{@data[1][5]}", "#{@data[2][5]}", "#{@data[3][5]}", "#{@data[4][5]}", "#{@data[5][5]}", "#{@data[6][5]}"],
        ["2", "#{@data[0][6]}", "#{@data[1][6]}", "#{@data[2][6]}", "#{@data[3][6]}", "#{@data[4][6]}", "#{@data[5][6]}", "#{@data[6][6]}"],
        [" ", "#{@data[0][7]}", "#{@data[1][7]}", "#{@data[2][7]}", "#{@data[3][7]}", "#{@data[4][7]}", "#{@data[5][7]}", "#{@data[6][7]}"],
        ["1", "#{@data[0][8]}", "#{@data[1][8]}", "#{@data[2][8]}", "#{@data[3][8]}", "#{@data[4][8]}", "#{@data[5][8]}", "#{@data[6][8]}"],
        [" ", "#{@data[0][9]}", "#{@data[1][9]}", "#{@data[2][9]}", "#{@data[3][9]}", "#{@data[4][9]}", "#{@data[5][9]}", "#{@data[6][9]}"],
        ["0", "床", "あん馬", "つり輪", "跳馬", "平行棒", "鉄棒", "全体"]
        
      ]

      # セルの高さ30、左上詰め詰め
      table event_graph, cell_style: { height: 15, width: 35, padding: 0 } do
        # 枠線なし
        cells.borders = []
        # 文字サイズ
        cells.size = 15
        cells.align = :center
        #columns(1).width = 180 # 男子：25*6 + 30, 女子： 35*4 + 30
        
        columns(0).borders = %i[right]
        row(-1).borders = %i[top]
        columns(0).row(-1).borders = %i[top right]
        columns(0).row(0).borders = []

        columns(0).size = 10
        row(0).size = 10
        row(-1).size = 10

        columns(0).width = 20

        

      end


      draw_text '来月の目標', at: [370, 198], size: 10

      bounding_box([290,180], :width=>270,:height=>360){
        table [
          [""],
          [""],
          [""],
          [""],
          [""],
          [""],
          [""]
        ], cell_style: {height: 21, width: 250, padding: 0} do
          cells.border_lines = %i[dotted]
          cells.borders = %i[top bottom]
        end
      }

    else
      @date_array = []
      @val_array = []
      @comment_array = []
      @ave_array = [0, 0, 0, 0, 0]
      
      n = 0
      for record in @records do
        n = n + 1
        day = (((record.date).to_s)[6,2]).to_i # 202005"08"のとこ
        @date_array.push(day)
        all = ((record.vt).to_i + (record.ub).to_i + (record.bb).to_i + (record.fx).to_i) * 100 / 4
        @values_for_ave = [(record.vt).to_i, (record.ub).to_i, (record.bb).to_i, (record.fx).to_i, all]
        all = (all.to_s)[0,1] + "." + (all.to_s)[1,2]
        @values = [(record.vt).to_i, (record.ub).to_i, (record.bb).to_i, (record.fx).to_i, all]
        @val_array.push(@values)
        @comment_array.push(record.comment)
        for j in 0..4 do
          @ave_array[j] = @ave_array[j] + @values_for_ave[j]
        end
      end

      @ave_array2 = [0, 0, 0, 0, 0]
      for j in 0..4 do
        @ave_array[j] = @ave_array[j] * 100 / n
        @ave_array2[j] = @ave_array[j]
        if @ave_array[j] >= 100
          @ave_array[j] = (@ave_array[j].to_s)[0,1] + "." + (@ave_array[j].to_s)[1,2]
        elsif
          @ave_array[j] = "0." + (@ave_array[j].to_s)[0,2]
        end
        

      end


      @first = []
      @second = []
      @third = []

      i = 0

      for d in 1..31 do
        yobi = (Time.new(((@records[0].date).to_s)[0,4], ((@records[0].date).to_s)[4,2], d)).wday
        if yobi == 0
          yobi_s = "日"
        end
        if yobi == 1
          yobi_s = "月"
        end
        if yobi == 2
          yobi_s = "火"
        end
        if yobi == 3
          yobi_s = "水"
        end
        if yobi == 4
          yobi_s = "木"
        end
        if yobi == 5
          yobi_s = "金"
        end
        if yobi == 6
          yobi_s = "土"
        end
        d_s = "#{d}" + "(#{yobi_s})"
        @first.push(d_s)
        if d == @date_array[i]
          @second.push(@val_array[i])
          @third.push(@comment_array[i])
          i = i + 1
        else
          @second.push(["-", "-", "-", "-", "-"])
          @third.push("")
        end
      end

      # 座標を表示
      #stroke_axis

      # 座標を指定して画像を表示する
      image 'app/assets/images/logo2.png', at: [0, 783], width: 120

      # 複雑なテーブルの表示
      rows = [
        [{ content: '月間レポート', rowspan: 2 }, "#{((@records[0].date).to_s)[0,4]}年#{((@records[0].date).to_s)[4,2]}月"],
        ["#{@user.name}　"]
      ]
      # セルの高さ30、左上詰め詰め
      table rows, cell_style: { height: 25, padding: 0 } do
        # 枠線なし
        cells.borders = []
        # 文字サイズ
        cells.size = 10

        columns(0).align = :right
        columns(0).size = 27
        columns(0).width = 370
        columns(0).padding = 5

        columns(1).align = :right
        columns(1).size = 12
        columns(1).width = 185

        columns(1).row(0).padding = 5
        
      end
      
      # 単純なテキストの表示
      if false
        text "#{@date_array[0]}"
        text "#{@val_array[0]}"
        text "#{@comment_array[0]}"
        text "#{@first[0]}"
        text "#{@second[0]}"
        text "#{@third[0]}"
      end
      
      move_down 8
      
      # 複雑なテーブルの表示
      rows = [
        ["日付", "跳馬", "段ち", "平均", "床", "全体", "コメント"],
        ["#{@first[0]}", "#{@second[0][0]}", "#{@second[0][1]}", "#{@second[0][2]}", "#{@second[0][3]}", "#{@second[0][4]}", "#{@third[0]}"],
        ["#{@first[1]}", "#{@second[1][0]}", "#{@second[1][1]}", "#{@second[1][2]}", "#{@second[1][3]}", "#{@second[1][4]}", "#{@third[1]}"],
        ["#{@first[2]}", "#{@second[2][0]}", "#{@second[2][1]}", "#{@second[2][2]}", "#{@second[2][3]}", "#{@second[2][4]}", "#{@third[2]}"],
        ["#{@first[3]}", "#{@second[3][0]}", "#{@second[3][1]}", "#{@second[3][2]}", "#{@second[3][3]}", "#{@second[3][4]}", "#{@third[3]}"],
        ["#{@first[4]}", "#{@second[4][0]}", "#{@second[4][1]}", "#{@second[4][2]}", "#{@second[4][3]}", "#{@second[4][4]}", "#{@third[4]}"],
        ["#{@first[5]}", "#{@second[5][0]}", "#{@second[5][1]}", "#{@second[5][2]}", "#{@second[5][3]}", "#{@second[5][4]}", "#{@third[5]}"],
        ["#{@first[6]}", "#{@second[6][0]}", "#{@second[6][1]}", "#{@second[6][2]}", "#{@second[6][3]}", "#{@second[6][4]}", "#{@third[6]}"],
        ["#{@first[7]}", "#{@second[7][0]}", "#{@second[7][1]}", "#{@second[7][2]}", "#{@second[7][3]}", "#{@second[7][4]}", "#{@third[7]}"],
        ["#{@first[8]}", "#{@second[8][0]}", "#{@second[8][1]}", "#{@second[8][2]}", "#{@second[8][3]}", "#{@second[8][4]}", "#{@third[8]}"],
        ["#{@first[9]}", "#{@second[9][0]}", "#{@second[9][1]}", "#{@second[9][2]}", "#{@second[9][3]}", "#{@second[9][4]}", "#{@third[9]}"],
        ["#{@first[10]}", "#{@second[10][0]}", "#{@second[10][1]}", "#{@second[10][2]}", "#{@second[10][3]}", "#{@second[10][4]}", "#{@third[10]}"],
        ["#{@first[11]}", "#{@second[11][0]}", "#{@second[11][1]}", "#{@second[11][2]}", "#{@second[11][3]}", "#{@second[11][4]}", "#{@third[11]}"],
        ["#{@first[12]}", "#{@second[12][0]}", "#{@second[12][1]}", "#{@second[12][2]}", "#{@second[12][3]}", "#{@second[12][4]}", "#{@third[12]}"],
        ["#{@first[13]}", "#{@second[13][0]}", "#{@second[13][1]}", "#{@second[13][2]}", "#{@second[13][3]}", "#{@second[13][4]}", "#{@third[13]}"],
        ["#{@first[14]}", "#{@second[14][0]}", "#{@second[14][1]}", "#{@second[14][2]}", "#{@second[14][3]}", "#{@second[14][4]}", "#{@third[14]}"],
        ["#{@first[15]}", "#{@second[15][0]}", "#{@second[15][1]}", "#{@second[15][2]}", "#{@second[15][3]}", "#{@second[15][4]}", "#{@third[15]}"],
        ["#{@first[16]}", "#{@second[16][0]}", "#{@second[16][1]}", "#{@second[16][2]}", "#{@second[16][3]}", "#{@second[16][4]}", "#{@third[16]}"],
        ["#{@first[17]}", "#{@second[17][0]}", "#{@second[17][1]}", "#{@second[17][2]}", "#{@second[17][3]}", "#{@second[17][4]}", "#{@third[17]}"],
        ["#{@first[18]}", "#{@second[18][0]}", "#{@second[18][1]}", "#{@second[18][2]}", "#{@second[18][3]}", "#{@second[18][4]}", "#{@third[18]}"],
        ["#{@first[19]}", "#{@second[19][0]}", "#{@second[19][1]}", "#{@second[19][2]}", "#{@second[19][3]}", "#{@second[19][4]}", "#{@third[19]}"],
        ["#{@first[20]}", "#{@second[20][0]}", "#{@second[20][1]}", "#{@second[20][2]}", "#{@second[20][3]}", "#{@second[20][4]}", "#{@third[20]}"],
        ["#{@first[21]}", "#{@second[21][0]}", "#{@second[21][1]}", "#{@second[21][2]}", "#{@second[21][3]}", "#{@second[21][4]}", "#{@third[21]}"],
        ["#{@first[22]}", "#{@second[22][0]}", "#{@second[22][1]}", "#{@second[22][2]}", "#{@second[22][3]}", "#{@second[22][4]}", "#{@third[22]}"],
        ["#{@first[23]}", "#{@second[23][0]}", "#{@second[23][1]}", "#{@second[23][2]}", "#{@second[23][3]}", "#{@second[23][4]}", "#{@third[23]}"],
        ["#{@first[24]}", "#{@second[24][0]}", "#{@second[24][1]}", "#{@second[24][2]}", "#{@second[24][3]}", "#{@second[24][4]}", "#{@third[24]}"],
        ["#{@first[25]}", "#{@second[25][0]}", "#{@second[25][1]}", "#{@second[25][2]}", "#{@second[25][3]}", "#{@second[25][4]}", "#{@third[25]}"],
        ["#{@first[26]}", "#{@second[26][0]}", "#{@second[26][1]}", "#{@second[26][2]}", "#{@second[26][3]}", "#{@second[26][4]}", "#{@third[26]}"],
        ["#{@first[27]}", "#{@second[27][0]}", "#{@second[27][1]}", "#{@second[27][2]}", "#{@second[27][3]}", "#{@second[27][4]}", "#{@third[27]}"],
        ["#{@first[28]}", "#{@second[28][0]}", "#{@second[28][1]}", "#{@second[28][2]}", "#{@second[28][3]}", "#{@second[28][4]}", "#{@third[28]}"],
        ["#{@first[29]}", "#{@second[29][0]}", "#{@second[29][1]}", "#{@second[29][2]}", "#{@second[29][3]}", "#{@second[29][4]}", "#{@third[29]}"],
        ["#{@first[30]}", "#{@second[30][0]}", "#{@second[30][1]}", "#{@second[30][2]}", "#{@second[30][3]}", "#{@second[30][4]}", "#{@third[30]}"],
        ["平均", "#{@ave_array[0]}", "#{@ave_array[1]}", "#{@ave_array[2]}", "#{@ave_array[3]}", "#{@ave_array[4]}", ""]
      ]

      # セルの高さ30、左上詰め詰め
      table rows, cell_style: { height: 15, width: 37.5, padding: 1 } do
        # 枠線なし
        cells.borders = []
        # 文字サイズ
        cells.size = 10
        # 枠線左と上だけ
        cells.borders = %i[left top right bottom]
        cells.align = :center
        #columns(1).width = 180 # 男子：25*6 + 30, 女子： 35*4 + 30
        
        # 1行目の背景色をff7500に
        row(1).background_color = 'EEEEEE'
        row(3).background_color = 'EEEEEE'
        row(5).background_color = 'EEEEEE'
        row(7).background_color = 'EEEEEE'
        row(9).background_color = 'EEEEEE'
        row(11).background_color = 'EEEEEE'
        row(13).background_color = 'EEEEEE'
        row(15).background_color = 'EEEEEE'
        row(17).background_color = 'EEEEEE'
        row(19).background_color = 'EEEEEE'
        row(21).background_color = 'EEEEEE'
        row(23).background_color = 'EEEEEE'
        row(25).background_color = 'EEEEEE'
        row(27).background_color = 'EEEEEE'
        row(29).background_color = 'EEEEEE'
        row(31).background_color = 'EEEEEE'

        row(0).height = 18 
        row(0).padding = 3
        row(32).height = 18
        row(32).padding = 3
        columns(0).background_color = 'FFFFFF'
        columns(0).width = 37
        columns(5).width = 30
        columns(6).width = 338
      end

      move_down 15

      #text "#{@val_array[0][6]}"

      # 座標を指定してテキストを表示する
      #draw_text 'ネコと和解せよ', at: [160, 50], size: 30


      @data = [
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", ""]
      ]

      @ave_array2[4] = @ave_array2[4] / 100
      
      for j in 0..4 do
        if @ave_array2[j] > 25
          @data[j][9] = "■"
        end
        if @ave_array2[j] > 75
          @data[j][8] = "■"
        end
        if @ave_array2[j] > 125
          @data[j][7] = "■"
        end
        if @ave_array2[j] > 175
          @data[j][6] = "■"
        end
        if @ave_array2[j] > 225
          @data[j][5] = "■"
        end
        if @ave_array2[j] > 275
          @data[j][4] = "■"
        end
        if @ave_array2[j] > 325
          @data[j][3] = "■"
        end
        if @ave_array2[j] > 375
          @data[j][2] = "■"
        end
        if @ave_array2[j] > 425
          @data[j][1] = "■"
        end
        if @ave_array2[j] > 475
          @data[j][0] = "■"
        end
      end

      event_graph = [
        [{content: "　種目別平均グラフ", colspan: 6 }],
        ["5", "#{@data[0][0]}", "#{@data[1][0]}", "#{@data[2][0]}", "#{@data[3][0]}", "#{@data[4][0]}"],
        [" ", "#{@data[0][1]}", "#{@data[1][1]}", "#{@data[2][1]}", "#{@data[3][1]}", "#{@data[4][1]}"],
        ["4", "#{@data[0][2]}", "#{@data[1][2]}", "#{@data[2][2]}", "#{@data[3][2]}", "#{@data[4][2]}"],
        [" ", "#{@data[0][3]}", "#{@data[1][3]}", "#{@data[2][3]}", "#{@data[3][3]}", "#{@data[4][3]}"],
        ["3", "#{@data[0][4]}", "#{@data[1][4]}", "#{@data[2][4]}", "#{@data[3][4]}", "#{@data[4][4]}"],
        [" ", "#{@data[0][5]}", "#{@data[1][5]}", "#{@data[2][5]}", "#{@data[3][5]}", "#{@data[4][5]}"],
        ["2", "#{@data[0][6]}", "#{@data[1][6]}", "#{@data[2][6]}", "#{@data[3][6]}", "#{@data[4][6]}"],
        [" ", "#{@data[0][7]}", "#{@data[1][7]}", "#{@data[2][7]}", "#{@data[3][7]}", "#{@data[4][7]}"],
        ["1", "#{@data[0][8]}", "#{@data[1][8]}", "#{@data[2][8]}", "#{@data[3][8]}", "#{@data[4][8]}"],
        [" ", "#{@data[0][9]}", "#{@data[1][9]}", "#{@data[2][9]}", "#{@data[3][9]}", "#{@data[4][9]}"],
        ["0", "跳馬", "段違い平行棒", "平均台", "床", "全体"]
        
      ]

      
      # セルの高さ30、左上詰め詰め
      table event_graph, cell_style: { height: 15, width: 50, padding: 0} do
        # 枠線なし
        cells.borders = []
        # 文字サイズ
        cells.size = 15
        cells.align = :center
        #columns(1).width = 180 # 男子：25*6 + 30, 女子： 35*4 + 30
        
        columns(0).borders = %i[right]
        row(-1).borders = %i[top]
        columns(0).row(-1).borders = %i[top right]
        columns(0).row(0).borders = []

        columns(0).size = 10
        row(0).size = 10
        row(-1).size = 10

        columns(0).width = 20


      end


      draw_text '来月の目標', at: [370, 198], size: 10

      bounding_box([290,180], :width=>270,:height=>360){
        table [
          [""],
          [""],
          [""],
          [""],
          [""],
          [""],
          [""]
        ], cell_style: {height: 21, width: 250, padding: 0} do
          cells.border_lines = %i[dotted]
          cells.borders = %i[top bottom]
        end
      }

    end

    draw_text '印刷して来月の目標を立てよう。', at: [410, 0], size: 8
  end

end