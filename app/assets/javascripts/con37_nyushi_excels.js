var lnk_csv = "";
var lnk_exl = "";

// 請求月計算 ／ 請求予定額計算
document.addEventListener('turbolinks:load', function() {
    
    // 別画面でエラーになる事象を回避
    if (document.getElementById('chk_seikyus_kbn1') == null) {
        return false;
    }

    // リンクの初期表示
     if (document.getElementById('chk_seikyus_kbn1').checked == true) {
        head_disp_coex(1);
     } else {
        head_disp_coex(2);
     }

    // 計算区分 = 請求月
    document.getElementById('chk_seikyus_kbn1').addEventListener('click', function() {
        head_disp_coex(1);
    })

    // 計算区分 = 請求予定額
    document.getElementById('chk_seikyus_kbn2').addEventListener('click', function() {
        head_disp_coex(2);
    })
    
    // 請求年月
    document.getElementById('txt_seikyus_ym').addEventListener('blur', function() {
    })
    
    // 実行
    document.getElementById('btn_seikyus_jikko').addEventListener('click', function() {
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })
    
    // CSV出力
    document.getElementById('lnk_seikyus_csv').addEventListener('click', function() {
        
        // 請求年月を取得
        let txt_seikyus_ym = document.getElementById('txt_seikyus_ym').value;

        // URLパラメータをセット
        let param = "?txt_seikyus_ym=" + txt_seikyus_ym;
        document.getElementById('lnk_seikyus_csv').setAttribute('href', lnk_csv + param);
    })

    // Excel出力
    document.getElementById('lnk_seikyus_excel').addEventListener('click', function() {

        // 請求年月を取得
        let txt_seikyus_ym = document.getElementById('txt_seikyus_ym').value;
        
        // URLパラメータをセット
        let param = "?txt_seikyus_ym=" + txt_seikyus_ym;
        document.getElementById('lnk_seikyus_excel').setAttribute('href', lnk_exl + param);
    })

}, false)

// ヘッダ部 表示
function head_disp_coex(kbn){
    
    switch ( kbn ) {
        case 1:
            document.getElementById("lnk_seikyus_csv_d").style.display    = "block";    // 表示
            document.getElementById("lnk_seikyus_csv_dl").style.display   = "block";    // 表示
            document.getElementById("lnk_seikyus_excel_d").style.display  = "none";     // 非表示
            document.getElementById("lnk_seikyus_excel_dl").style.display = "none";     // 非表示
            break;
        case 2:
            document.getElementById("lnk_seikyus_csv_d").style.display    = "none";     // 非表示
            document.getElementById("lnk_seikyus_csv_dl").style.display   = "none";     // 非表示
            document.getElementById("lnk_seikyus_excel_d").style.display  = "block";    // 表示
            document.getElementById("lnk_seikyus_excel_dl").style.display = "block";    // 表示
            break;
    }

    // マウスカーソルをデフォルト
    document.body.parentElement.style.cursor = "default";

    // URLのパラメータの初期値を退避
    lnk_csv = document.getElementById('lnk_seikyus_csv').href;
    lnk_exl = document.getElementById('lnk_seikyus_excel').href;
}
