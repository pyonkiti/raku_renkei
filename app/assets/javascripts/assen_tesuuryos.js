// 斡旋手数料の請求書出力
document.addEventListener('turbolinks:load', function() {

    // マウスカーソルをデフォルト
    document.body.parentElement.style.cursor = "default";

    // 請求年月日
    document.getElementById('txt_seikyu_ym').addEventListener('click', function(){
    })
    
    // 実行
    document.getElementById('btn_jikko').addEventListener('click', function(){
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

    // Excel出力
    document.getElementById('lnk_seikyus_excel').addEventListener('click', function(){
    })

}, false)