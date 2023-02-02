// ユーザー入力
document.addEventListener('turbolinks:load', function() {
    
    // パスワード表示チェック
    document.getElementById('users_passcheck').addEventListener('change', function() {
        head_disp(1);
    })

}, false)


// ヘッダ部 表示
function head_disp(kbn){
    
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
