# 共通モジュール
module  Common
    
    # ---------------------------------------------------------
    # ファイルの取り込みをチェックをする
    # ---------------------------------------------------------
    def self.check_file(file)

        if file.nil?
            return 1
        end

        content = File.read(file.path)
        if (NKF.guess(content).to_s == "UTF-8")
        else
            return 2
        end

        return 0
    end

    # ---------------------------------------------------------
    # 数値かどうかのチェックをする
    # ---------------------------------------------------------
    def self.check_integer(data)

        # 空白は0になります
        if (/^[0-9]+$/ =~ data.to_s)
            ret = data.to_i
        else
            ret = 0
        end
        return ret
    end

    # ---------------------------------------------------------
    # 空白であれば、''の文字列に変換する
    # ---------------------------------------------------------
    def self.change_kara(data)

        case data
            when nil
                "\'\'"
            when ""
                "\'\'"
            else
                "\'#{data}\'"
        end
    end
    
    # ---------------------------------------------------------
    # ２つの年月を比較して、月の差を取得
    # strYM, endYMの引数は、数値型で202209でもOK
    # 文字列で"2022-09" or "2022/09" or "" or nil でもOK
    # 日付型では受け渡さないこと
    # ＜テスト結果＞
    # strYM = 202209; endYM = 202209      # => 0
    # strYM = 202209; endYM = 202210      # => 1
    # strYM = 202209; endYM = 202301      # => 4
    # strYM = 202201; endYM = 202212      # => 11
    # strYM = 202301; endYM = 202401      # => 12
    # strYM = 202501; endYM = 202401      # => -12
    # ---------------------------------------------------------
    def self.datediff(strYM, endYM)

        strYM = strYM.to_s
        endYM = endYM.to_s
        
        ary = []

        ary << strYM.slice(0, 4).to_i
        ary << strYM.slice(4, 2).to_i

        ary << endYM.slice(0, 4).to_i
        ary << endYM.slice(4, 2).to_i

        (ary[2] * 12 + ary[3]) - (ary[0] * 12 + ary[1])       # 年月（自）－ 年月（至）
    end

    # ---------------------------------------------------------
    # 開始（終了）年月が空白の場合、デフォルト値をセットする
    # wdateの引数は、"2022/10"で渡す 数値型の202210でも問題ない
    # ＜テスト結果＞
    #  puts get_strendym(1 , "")           # => 210012
    #  puts get_strendym(0 , "")           # => 190001
    #  puts get_strendym(0 , "2022/10")    # => 202210
    #  puts get_strendym(1 , "2022/10")    # => 202210
    # ---------------------------------------------------------
    def self.get_strendym(kbn, wdate)

        wdate = wdate.to_s

        if wdate == ""
            ret = case kbn
                when 0 then 190001          # 有償開始年月のMIN
                when 1 then 210012          # 有償終了年月のMAX
            end
        else
            ret = wdate.delete("/").to_i
        end
        ret
    end
end