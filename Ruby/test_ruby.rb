



def aaa(*aa)

    # puts aa
    return aa[0][2]
end

puts aaa([1,2,3])



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


