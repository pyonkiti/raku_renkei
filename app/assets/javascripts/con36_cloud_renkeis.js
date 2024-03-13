// Cloud連携
document.addEventListener('turbolinks:load', function() {
    
    // 別画面でエラーになる事象を回避
    if (document.getElementById('chk_syori_kbn1') == null) { return false; }

    // 初期表示
    if (document.getElementById('chk_syori_kbn1').checked == null || document.getElementById('chk_syori_kbn1').checked == true) {
        head_disp_cloud_ren(1);
    } else {
        head_disp_cloud_ren(2);
    }

    // インポート１
    document.getElementById('tag_submit_seikyu').addEventListener('click', function() {
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

    // インポート２
    document.getElementById('tag_submit_shisetu').addEventListener('click', function() {
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

    // 実行
    document.getElementById('btn_renkei_jikko').addEventListener('click', function() {
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

    // 新規/廃止ユーザーのExcel出力
    document.getElementById('chk_syori_kbn1').addEventListener('click', function() {
        head_disp_cloud_ren(1);

    })
    
    // 新規施設のExcel出力
    document.getElementById('chk_syori_kbn2').addEventListener('click', function() {
        head_disp_cloud_ren(2);
    })
}, false)

// ヘッダ部表示
function head_disp_cloud_ren(kbn) {
    
    switch (kbn) {
        case 1:
            document.getElementById("lnk_cloud_renkeis1").style.display = "block";
            document.getElementById("lnk_cloud_renkeis2").style.display = "none";

            break;
        case 2:
            document.getElementById("lnk_cloud_renkeis1").style.display = "none";
            document.getElementById("lnk_cloud_renkeis2").style.display = "block";
            break;
    }

    // マウスカーソルをデフォルト
    document.body.parentElement.style.cursor = "default";
}