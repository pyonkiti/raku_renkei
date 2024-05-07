// 請求月数の例外登録
document.addEventListener('turbolinks:load', function() {
    
    // 請求キーリンク
    document.getElementById('txt_seikyu_key_link').focus();
    $("#lbl_seikyu_key_link").tooltip();
    $("#txt_seikyu_key_link").tooltip();

    // 施設名
    $("#lbl_sisetu_nm").tooltip();
    $("#txt_sisetu_nm").tooltip();

    // 請求月数
    $("#lbl_seikyu_m_su").tooltip();
    $("#txt_seikyu_m_su").tooltip();

    // 備考（ユーザー名）
    $("#lbl_biko_user").tooltip();
    $("#txt_biko_user").tooltip();
    
    // 備考（仕様の説明）
    $("#lbl_biko_siyou").tooltip();
    $("#txt_biko_siyou").tooltip();

    document.getElementById('tag_nyushi_submit1').addEventListener('click', function() {
        // マウスカーソルを砂時計
        document.body.parentElement.style.cursor = "wait";
    })

}, false)
