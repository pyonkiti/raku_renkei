// 請求月計算 ／ 請求予定額計算
document.addEventListener('turbolinks:load', function() {
    
    // 別画面でエラーになる事象を回避
    if (document.getElementById('chk_seikyus_kbn1') == null) {
        return false;
    }

    // 初回、load時に実行する
    head_disp();

    // 計算区分 = 請求月
    document.getElementById('chk_seikyus_kbn1').addEventListener('click', function() {
        head_disp(1);
    })

    // 計算区分 = 請求予定額
    document.getElementById('chk_seikyus_kbn2').addEventListener('click', function() {
        head_disp(2);
    })
    
    // 実行
    document.getElementById('btn_jikko').addEventListener('click', function() {
    })

    // CSV出力
    document.getElementById('lnk_seikyus_csv').addEventListener('click', function() {
    })

    // Excel出力
    document.getElementById('lnk_seikyus_excel').addEventListener('click', function() {
    })
}, false)



// ヘッダ部 表示
function head_disp(kbn = 1){
    
    if ( kbn == 1 ) {
        document.getElementById("lnk_seikyus_csv_d").style.display    = "block";    // 表示
        document.getElementById("lnk_seikyus_csv_dl").style.display   = "block";    // 表示
        document.getElementById("lnk_seikyus_excel_d").style.display  = "none";     // 非表示
        document.getElementById("lnk_seikyus_excel_dl").style.display = "none";     // 非表示
    }else{
        document.getElementById("lnk_seikyus_csv_d").style.display    = "none";     // 非表示
        document.getElementById("lnk_seikyus_csv_dl").style.display   = "none";     // 非表示
        document.getElementById("lnk_seikyus_excel_d").style.display  = "block";    // 表示
        document.getElementById("lnk_seikyus_excel_dl").style.display = "block";    // 表示
    }
}
