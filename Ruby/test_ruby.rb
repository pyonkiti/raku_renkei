
# ---------------------------------------------------------
# 経過時間（分:秒）を計測
# ---------------------------------------------------------
def test_time
    
    time_str = Time.now.to_i
    sleep(3)
    time_end = Time.now.to_i
    time_ret = time_end - time_str
    puts (Time.at(time_ret)).strftime("%M:%S")
end

# ---------------------------------------------------------
# 配列をフラットにする
# ---------------------------------------------------------
def test_flatten
    ary = [1, 2, [3], [4, 5,], [6, 7], [8, [9, [10]]]]
    ary.flatten!
end

# ---------------------------------------------------------
# 文字列の右詰め
# ---------------------------------------------------------
def test_idx
    (1..10).each_with_index do |idx|
        puts idx.to_s.rjust(2)
    end
end

# ---------------------------------------------------------
# 文字列の配列を生成する方法
# ---------------------------------------------------------
def test_arry
    ary = ('000'..'100').to_a
    # ary = [*('0'..'9')]
    puts "#{ary}"
end

# ---------------------------------------------------------
# 文字列の中に全角が含まれるかチェック
# ---------------------------------------------------------
def test_zenkaku(str)

    if str =~ /[^ -~｡-ﾟ]/
        puts "全角が含まれます"
    else
        puts "全角は含まれません"
    end

    if /[^ -~｡-ﾟ]/.match(str)
        puts "全角が含まれます"
    else
        puts "全角は含まれません"
    end

    if str.match(/[^\x01-\x7E｡-ﾟ]/)
        puts "全角が含まれます"
    else
        puts "全角は含まれません"
    end
end

# ---------------------------------------------------------
# 素数を求める
# ---------------------------------------------------------
def test_prime
    require 'prime'
    puts Integer.each_prime(20).to_a
end

# ---------------------------------------------------------
# 三項演算子の使い方
# ---------------------------------------------------------
def test_sankou(flg)

    ret = "#{(flg.to_s.strip == "" ? "aa" : "bb")}" + "cc"
    puts ret

    ret = (flg.to_s.strip == "" ? "aa" : "bb" + " ") + "cc"
    puts ret
end

# ---------------------------------------------------------
# 配列の最後の要素だけ書き換える
# ---------------------------------------------------------
def test_arry

    msg = []
    msg << "111"
    msg << "222"
    msg << "333"

    msg[-1] = msg[-1] + "444"
    puts msg
end

# ---------------------------------------------------------
# 処理の経過時間を計測する
# ---------------------------------------------------------
def test_runtime

    time_measure = {str: 0, end: 0}

    time_measure[:str] = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    sleep (5)

    time_measure[:end] = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    aa = Time.at(time_measure[:end] - time_measure[:str]).utc.strftime('%M分%S秒')
    puts aa
end

# ---------------------------------------------------------
# ハッシュの中に配列を作成する
# ---------------------------------------------------------
def test_hash_create

    hash = {}
    hash["err"] = []
    hash["err"] << "エラーです"
    hash["err"] << "エラーですよ"

    hash["ok"] = []
    hash["ok"] << "OKです"
    hash["ok"] << "OKですよ"

    puts hash
end

# ---------------------------------------------------------
# ハッシュの取得方法
# ---------------------------------------------------------
def test_hash(col)

    if col == 10
        column = {head: {yyy: 53, tiy: 36, siy: 3, sum: 31}, meisai: {kis: 6, kok: 16, ser: 30, tan: 39, suu: 47, kin: 52}}
    else
        column = {head: {yyy: 40, tiy: 29, siy: 1, sum: 24}, meisai: {kis: 4, kok: 12, ser: 25, tan: 32, suu: 37, kin: 42}}
    end

    
    column = {head: {yyy: 53, tiy: 36, siy: 3, sum: 31}, meisai: {kis: 6, kok: 16, ser: 30, tan: 39, suu: 47, kin: 52}} if col == 10
    column = {head: {yyy: 40, tiy: 29, siy: 1, sum: 24}, meisai: {kis: 4, kok: 12, ser: 25, tan: 32, suu: 37, kin: 42}} if col == 10

    # column[:head]
    # column[:head][:tiy]
end

# ---------------------------------------------------------
# ハッシュの作り方
# ---------------------------------------------------------
def test_hash2

    # ret = {"a" => "111","b" => "b"}       # OK
    # ret = {1 => 111, 2 => 55}             # OK
    # ret = {1 => "111", 2 => "55"}         # OK
    # ret = {1 => "aa", 2 => "bb"}          # OK
    # ret = {a => "111", b => "b"}          # エラー

    # ret = {a: "111", b: "b"}              # OK
    # ret = {a: 111, b: 222}                # OK
    # ret = {a: 111, b: b}                  # エラー

    return ret
end

# ---------------------------------------------------------
# case文の使い方
# ---------------------------------------------------------
def test_case(kbn)
    
    aa = []
    aa << case kbn
        when 1 
            ["111","b"]
        when 2
            ["222","c"]
    end

    bb = {}
    bb = case kbn
        when 1 
            {"a" => "111","b" => "b"}
        when 2
            {"a" => "112","b" => "bb"}
    end
    return aa, bb
end

# ---------------------------------------------------------
# Excel罫線の種類を調べる
# ---------------------------------------------------------
def test_rubyxl

    require 'rubyXL'
    require 'rubyXL/convenience_methods'

    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]

    sT_BorderStyle = %w{ none thin medium dashed dotted thick double hair mediumDashed dashDot mediumDashDot dashDotDot slantDashDot }
    sT_BorderStyle.each_with_index do |val, idx|
         worksheet.add_cell(idx, 0, val).change_border(:bottom, val)
    end
    workbook.write('./Ruby/sample_1.xlsx')
end

# ---------------------------------------------------------
# ブロック内の変数の有効範囲の確認
# ---------------------------------------------------------
def test_idx
    idx = 100
    5.times do |idx|
        puts "idx1 = #{idx}"
        if idx == 3
            3.times do |idx|
                puts "idx2 = #{idx}"
            end
        end
    end
    puts "idx3 = #{idx}"
end

# ---------------------------------------------------------
# ファイル存在チェック
# ---------------------------------------------------------
def test_exists
    
    require 'fileutils'

    # puts File.exists?("./excel/moto/支払手数料明細表.xlsx")
    # puts File.exists?("./excel/サンプル.xlsx")

    msg  = nil
    hash = {"moto_path" => "./excel/moto/", "saki_path" => "./excel/"}
    file = ["支払手数料明細表(10明細)_元.xlsx", "支払手数料明細表(21明細)_元.xlsx"]
    
    file.each do |file|
        if !File.exists?(hash.fetch("moto_path") + file)
            msg = "「#{file}」 が存在しません。雛形となるファイルを所定のフォルダにセットしてください。"
            return false, msg
        end
    end
    return true, msg
end

# ---------------------------------------------------------
# ファイルコピー
# ---------------------------------------------------------
def test_filecopy

    require 'fileutils'

    hash = {"moto_path" => "./excel/moto/", "saki_path" => "./excel/"}
    file = ["支払手数料明細表(10明細)_元.xlsx", "支払手数料明細表(21明細)_元.xlsx"]

    # FileUtils.cp("./excel/moto/支払手数料明細表.xlsx", "./excel/サンプル.xlsx")

    # コピー先に同名のファイルがあれば上書きされるだけなので事前削除は不要
    file.each do |file|
        FileUtils.cp(hash.fetch("moto_path") + file, hash.fetch("saki_path") + file.delete("_元"))
    end
end

# ---------------------------------------------------------
# 文字置換
# ---------------------------------------------------------
def test_delete
    aa.gsub!(/ＮＥＣプラットフォームズ株式会社/, "").strip!
    puts aa
end

# ---------------------------------------------------------
# ファイル削除
# ---------------------------------------------------------
def test_filemove
    
    require 'fileutils'

    FileUtils.rm("./excel/サンプル.xlsx")
    FileUtils.rm("./excel/bb.xlsx")
end

# ---------------------------------------------------------
# 引数に名前を付ける
# ---------------------------------------------------------
def test_hikisu(a,b,aa:, bb:)

    if aa == 1
        puts "#{aa}#{bb}"
    else
        puts "ちがう"
    end
end

# ---------------------------------------------------------
# GoTo文
# ---------------------------------------------------------
def test_goto(aa)
    
    catch(:goto) do
        case aa
            when 1 then 
                puts "11"
                throw :goto
            when 2 then 
                puts "22"
        end
        puts "終わり"
    end
end

# ---------------------------------------------------------
# 配列の中のハッシュの取得
# ---------------------------------------------------------
def test_hash
    
    arry = [{"no"=>"1","key"=>"11"},{"no"=>"2","key"=>"22"},{"no"=>"3","key"=>"33"}]
    
    arry.each_with_index do |ret, i|
        
        arry2 = []
        arry2 << ret["no"]
        arry2 << ret["key"]
        # puts "#{arry2}"
        puts "#{ret["no"]}"
    end
end

# ---------------------------------------------------------
# 1日前の日付を取得
# ---------------------------------------------------------
def test_date(w_nyukin_ymd)

    require 'date'

    aa = w_nyukin_ymd.to_s.slice(0, 6) + "01"
    bb = Date.parse(aa)
    cc = bb.prev_day(1)

    puts aa
    puts bb
    puts cc

    dd = Date.parse(w_nyukin_ymd.to_s.slice(0, 6) + "01").prev_day(1)
    ee = Date.parse(w_nyukin_ymd.to_s.slice(0, 6) + "01").prev_day(1).to_s
    puts dd.class
    puts ee.class
end

#puts test_date(20230331)



# ---------------------------------------------------------
# JTS→UTCに変換する
# ---------------------------------------------------------
def test_time
    
    require 'active_support/time'
    puts Time.current.ago(9.hours)
    puts Time.current.zone
end

# ---------------------------------------------------------
# 先頭の０埋めを省いて文字列にする
# ---------------------------------------------------------
def test_zero(data)

    puts data
    puts data.to_i.to_s
end

# ---------------------------------------------------------
# case文でネストしたら、ネストの階層の一番深いのが有効になる
# ---------------------------------------------------------
def test_case(mm)
    case mm
        when 1 then "OK"
            case mm
                when 1 then "AA"
                    case mm
                        when 1 then "BB"
                    end
            end
        when 2 then "NG"
    end
end

def get_time
    # RubyでTime.currentを使うには、これが必要
    require 'active_support/time'
    aa = Time.current.strftime("%m")
    puts aa
end

class Test_class

    class << self
        def test_meth
            puts self.class.name.to_s                               # ×
            puts self.class.to_s                                    # ×
            puts self.name.to_s + "." + __method__.to_s             # クラス名はこれで取れてくる
            # puts self.method_name.to_s                              # ×
        end
    end
end
