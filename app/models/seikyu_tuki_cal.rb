class SeikyuTukiCal < ApplicationRecord

    belongs_to :sisetu_kanribu_teisyutu0                             # 施設管理部提出_結合

    class << self
        
        # 請求月計算のメイン処理
        def proc_main(icnt, seikyu_ym)

            table_delete if (icnt == 0)
            unless proc1(seikyu_ym)
                return false
            end
            return true
        end

        # 請求月計算のCSVに出力
        def proc_csv(ex_seikyu)

            CSV.generate( headers: true, force_quotes: true) do |csv|

                csv << %w(自動採番 請求月数 印刷フラグ)
                
                ex_seikyu.each do |seikyu|
                    arry = []
                    arry << sprintf("%09d", seikyu.sisetu_kanribu_teisyutu0_id)
                    arry << seikyu.seikyu_m_su
                    arry << seikyu.print_flg
                    csv  << arry
                end
            end
        end

        private

        # 管理部提出データ0_統合 ⇒ 請求月計算への更新
        def proc1(seikyu_ym)

            begin
                table0 = SisetuKanribuTeisyutu0.all.order(:seikyu_key_link).order(:sisetu_cd)
                
                table0.each do |tbl0|

                    # 支払期間コード、有償開始年月、有償終了年月
                    ary = ["#{tbl0.siharai_kikan_cd}", "#{tbl0.yuusyou_kaishi_ym}", "#{tbl0.yuusyou_syuryo_ym}"]
                    
                    ituki = get_calctuki(ary, seikyu_ym)                        # 請求月数の計算
                    sprnt = get_outjyoken(ary, seikyu_ym)                       # 印刷フラグの算出
                    ituki = 0 if (sprnt == "無")
                    
                    sql  = ""
                    sql += "Insert Into seikyu_tuki_cals( "
                    sql += "seikyu_key_link,"
                    sql += "yuusyou_kaishi_ym,"
                    sql += "yuusyou_syuryo_ym,"
                    sql += "seikyu_m_su,"
                    sql += "siharai_kikan_cd,"
                    sql += "print_flg,"
                    sql += "seikyu_ym,"
                    sql += "sisetu_kanribu_teisyutu0_id"
                    sql += " ) "
                    sql += "Values ( "
                    sql += "#{Common.change_kara(tbl0.seikyu_key_link)},"
                    sql += "#{Common.change_kara(tbl0.yuusyou_kaishi_ym)},"
                    sql += "#{Common.change_kara(tbl0.yuusyou_syuryo_ym)},"
                    sql += "#{ituki},"                                          # 請求月数
                    sql += "#{Common.change_kara(tbl0.siharai_kikan_cd)},"
                    sql += "#{Common.change_kara(sprnt)},"                      # 印刷フラグ
                    sql += "#{seikyu_ym.delete("-")},"                          # 請求年月
                    sql += "#{tbl0.id}"
                    sql += " )"

                    res = ActiveRecord::Base.connection.execute(sql)
                end
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # 請求月計算テーブルを全件削除
        def table_delete
            connection.execute "TRUNCATE TABLE seikyu_tuki_cals;"
        end

        # ---------------------------------------------------------
        # 請求月数の計算
        #  ary[0] : 支払区分コード  ary[1]: 有償開始年月  ary[2]: 有償終了年月
        #
        #＜仕様メモ＞
        #【毎月請求】
        #  01   毎月
        #【半月請求】
        #  11  半期（9月/3月）
        #  12  半期（8月/2月）
        #  13  半期（4月/10月）
        #  14  半期（4月/9月/3月）       ※システム対応を行わない
        #  15  四半期（6月/9月/12月/3月）※システム対応を行わない
        #【年度請求】
        #  21  年度末（3月）
        #  22  期初一括（4月）           ※システム対応を行わない
        # ---------------------------------------------------------
        def get_calctuki(ary, seikyu_ym)
            
            case ary[0]
                when "01"
                    1
                else
                    case ary[0].to_i
                        when 11 .. 13
                            iTuki = 6
                        else
                            iTuki = 12
                    end

                    # メモ情報 : seikyu_ymは1月の時は、2022-1ではなく、2022-01が入ってくる
                    aa = seikyu_ym.delete("-").to_i                                                                          # 画面の請求年月
                    bb = Time.local(seikyu_ym.split("-")[0], seikyu_ym.split("-")[1]).ago(iTuki.month).strftime("%Y%m").to_i # 画面の請求年月 - 6(12)ヶ月
                    
                    strYM = ary[1].delete("/").to_i             # 有償開始年月
                    endYM = ary[2].delete("/").to_i             # 有償終了年月
                
                    strYM = 0 if strYM <= bb
                    endYM = 0 if endYM >  aa

                    # 前月請求日 ＜ 有償開始年月,有償終了年月 ≦ 請求日
                    if strYM != 0
                        if endYM != 0
                            tuki = Common.datediff(strYM, endYM) + 1
                            if tuki < iTuki
                                return tuki
                            end
                        end
                    end

                    # 前月請求日 ＜ 有償開始年月 ≦ 請求
                    if strYM != 0
                        if bb < strYM and strYM <= aa
                            tuki = Common.datediff(strYM, aa) + 1
                            return tuki
                        end
                    end

                    # 前月請求日 ＜ 有償終了年月 ≦ 請求日
                    if endYM != 0
                        if bb < endYM and endYM <= aa
                            tuki = Common.datediff(bb, endYM)
                            return tuki
                        end
                    end
                    return iTuki
            end
        end

        # 印刷フラグの算出
        # ary[0] : 支払区分コード ary[1]: 有償開始年月  ary[2]: 有償終了年月
        def get_outjyoken(ary, seikyu_ym)

            case ary[0]
                when "01"                           # 毎月請求
                    if Common.get_strendym(0, ary[1]) <= seikyu_ym.delete("-").to_i
                            if seikyu_ym.delete("-").to_i <= Common.get_strendym(1, ary[2])
                            return "有"
                        end
                    end
                    return "無"
                else                                # 半期 / 年次請求
                    case ary[0].to_i
                        when 11 .. 13
                            iTuki = 6
                        else
                            iTuki = 12
                    end

                    #【パターン２、６の場合】
                    # 開始年月がどうであれ、終了年月（終了年月が空白でない場合のみ）≧ 画面年月－6(12)ヶ月の場合は請求しない
                    if ary[2].delete("/").to_i != 0
                        iDifYmd = Common.datediff(ary[2].delete("/").to_i, seikyu_ym.delete("-").to_i)
                        return "無" if iDifYmd >= iTuki
                    end

                    #【パターン１３～１６の場合】
                    # 終了年月がどうであれ、開始年月 > 画面年月の場合は請求しない
                    if Common.get_strendym(0, ary[1]) > seikyu_ym.delete("-").to_i
                        return "無"
                    end
                    return "有"
            end
        end
    end
end
