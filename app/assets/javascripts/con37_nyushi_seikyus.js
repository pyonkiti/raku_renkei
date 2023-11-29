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

    // 実行
    document.getElementById('btn_nyushi_jikko').addEventListener('click', function() {
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

}, false)
