// ユーザー入力
document.addEventListener('turbolinks:load', function() {
    
    // 別画面でエラーになる事象を回避
    if (document.getElementById('users_passcheck') == null){return false;}

    // パスワード表示チェック
    document.getElementById('users_passcheck').addEventListener('change', function() {
        head_disp_msur(1);
    })

}, false)

// ヘッダ部 表示
function head_disp_msur(kbn){
    
    switch (kbn) {
        case 1:

            let txt_pass = document.getElementById("usr_password");
            
            if (txt_pass.type === "password"){
                txt_pass.type = "text"
            }else{
                txt_pass.type = "password"
            };
            break;
    }
}
