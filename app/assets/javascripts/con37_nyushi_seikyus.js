// 入金一覧Excel ／ 仕入一覧CSV出力
document.addEventListener('turbolinks:load', function() {
    
    // 別画面でエラーになる事象を回避
    if (document.getElementById('tag_nyushi_submit1') == null) { return false; }

    // インポート１
    document.getElementById('tag_nyushi_submit1').addEventListener('click', function() {
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

    // インポート２
    document.getElementById('tag_nyushi_submit2').addEventListener('click', function() {
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

    // インポート３
    document.getElementById('tag_nyushi_submit3').addEventListener('click', function() {

        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

    // 前月分として実行チェック
    document.getElementById('chk_zengetu').addEventListener('click', function() {
    })
    
    // 実行
    document.getElementById('lnk_nyushi_jikko').addEventListener('click', function() {
        
        // チェックをGETでparamsに送信する
        let lnk_nyushi_jikko = document.getElementById('lnk_nyushi_jikko');
        let param    = "?chk_zengetu=" + document.getElementById('chk_zengetu').checked;
        lnk_nyushi_jikko.setAttribute('href', lnk_nyushi_jikko.href + param);
        
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })
    
}, false)
