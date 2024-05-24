# 開発環境から開発サーバー（本番環境）にRailsプロジェクトをコピーする
# 本番環境にコピーする必要があるファイルやディレクトリが増えれば、都度、配列に追加する
# ＜使い方＞ $ruby scp.rb password 引数には開発サーバーにsofinetでログインするときのパスワードを渡す
class ProcScp

    class << self
    
        # 引数の入力チェック
        def check_arg()

            if ARGV.size().to_i == 0
                msg = "引数が指定されていません。"
                return false, msg
            end

            if ARGV.size().to_i > 1
                msg = "引数は１個で指定してください。"
                return false, msg
            end
            return true, nil
        end

        # scpコマンド処理
        def proc_scp(argv, flg)
            
            param_hash = {
                path_moto: "/vagrant/raku_renkei",              # コピー元
                # path_saki: "/home/tanaka/test_scp",           # コピー先（テスト用）
                path_saki: "/home/tanaka/raku_renkei",          # コピー先（本番用）
                server: "sofinet@192.168.19.11",                # 開発サーバー
                password: "#{argv}"                             # パスワード
            }

            # プロジェクト配下の隠しファイル（個別に指定しないとコピーできない事情がある）
            filea_arry = %w(.env .gitignore .rspec .ruby-version)

            # プロジェクト配下のファイル（個別に指定しないとコピーできない事情がある）
            filef_arry = %w(cat config.ru Gemfile Gemfile.lock package.json Rakefile README.md yarn.lock scp.rb)

            # プロジェクト配下のディレクトリ
            direc_arry = %w(app bin config db excel lib node_modules public storage vendor)

            # db/seeds.rbだけ
            seeds_arry = %w(seeds.rb)

            all_arry_max = (filea_arry + filef_arry + direc_arry + seeds_arry).max_by(&:length)
            
            all_arry = case flg
                when "all"  then (filea_arry + filef_arry + direc_arry)
                when "seed" then seeds_arry
                else []
            end

            return false if all_arry == []
            
            all_arry.each_with_index do |fil, idx|
                
                cmd = case flg
                    when "all"
                        "sshpass -p #{param_hash[:password]} sudo scp -rp #{param_hash[:path_moto]}/#{fil} #{param_hash[:server]}:#{param_hash[:path_saki]}"
                    when "seed"
                        "sshpass -p #{param_hash[:password]} sudo scp -rp #{param_hash[:path_moto]}/db/#{fil} #{param_hash[:server]}:#{param_hash[:path_saki]}/db"
                    else
                        ""
                end

                return false if system(cmd) != true
                puts "[#{idx.to_s.rjust(2)}] " + "#{fil}".ljust(all_arry_max.length) + " -> Copy OK"
            end

            return true
        end
    end
end

ret, msg = ProcScp.check_arg
if ret != true
    puts msg
    exit
end

# 第二引数（all:全てのファイルをコピー、seed:seedsファイルのみをコピー）
if ProcScp.proc_scp(ARGV[0].to_s, "all") != true
    puts "処理が異常終了しました。"
else
    puts "処理が正常終了しました。"
end
