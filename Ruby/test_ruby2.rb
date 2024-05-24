



# ファイルのタイプスタンプを取得
def test_filetime
    puts File.mtime(__FILE__)
    puts File.mtime(__FILE__).year
    puts File.mtime(__FILE__).month
end

# プログラム名とパスを取得する
def test_filename
    puts __FILE__
    puts File.basename(__FILE__)
    puts File.dirname(__FILE__)
end

# スレッド処理
def test_thread
    arry = []

    3.times {
      arry << Thread.new {
        puts "Hello World " # このコードはまずい
        sleep(2)
      }
    }
    arry.each do |res|
      puts res
    end
end

# selectの使い方
def test_select
    ary = (1..10).to_a
    res = ary.map {|val| val.even?}
    puts res

    res = ary.select {|val| val.even?}
    puts res

    res = ary.select {|val| val == 5}
    puts res

end

# mapとmap!の使い方
def test_map
    ary = (1..10).to_a
    puts ary
    puts "-----"

    res = ary.map {|val| val + 1}
    puts res
    puts "-----"
    puts ary
    puts "-----"

    ary.map! {|val| val + 1}
    puts ary
end

# setとは集合体のこと、使い道に関しては分からない
def test_set
    require 'set'
    set = Set.new([1, 2, 1])
    puts set
    res = set.add(3)
    puts res

    set.each do |val|
      puts val
    end
end

# any 配列の中に条件にあうものが１つでもあればtrue
def test_arry
    ary = (1..10).to_a
    res = ary.any? {|val| val == 5 }    
    puts res
end

# ハッシュにキーと値をセット
def test_hash
    hash = {}
    hash[:key1] = "value1"
    hash[:key2] = "value2"
    puts hash
end

# ディレクトリ関係
def test_dir
    puts Dir.pwd            # カレントディレクトリ
    puts ENV["PATH"]          # OSの環境変数を取得
    puts __FILE__             # 自分のプログラム名をパス付で取得
end

# 配列の要素をこのように取得する方法もある
def test_arry
    a, b = [1, 2]
    puts  a
    puts  b
end

# 文字列の中にある文字が含まれているか確認
def test_index
    aa = "astrocあhemistry".index("ああ")
    puts aa
end

# 配列の先頭と末尾に要素を１つ追加
def test_unshift
    ary = ["one", "two", "three"]
    ary.unshift "aaa"
    puts ary

    ary.push "bbb"
    puts ary
end

# 配列の最後の要素を１つ削除する
def test_pop
    s = ["one", "two", "three"]
    puts s.pop                  # => ["one", "two"]
    puts s.pop                  # => ["one"]
end

# lazyをつけると配列の生成が早くなる
def test_lazy
    ary = ('000'..'100').lazy.to_a
    # ary = ('000'..'100').to_a
    # ary = [*('0'..'9')]
    puts "#{ary}"
end

# 2で割って0になる値、先頭５つを取得
def test_select
    res = (1..100).select{ |item| item.modulo(2) == 0}.take(5)
    return res
end