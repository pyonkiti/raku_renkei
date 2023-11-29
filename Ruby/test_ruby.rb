
# ---------------------------------------------------------
# 
# ---------------------------------------------------------
def test_set
    
    aa = Dir.pwd            # フルパス
    bb = Dir.chdir("/vagrant")
    puts bb
    

    
end

test_set

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


