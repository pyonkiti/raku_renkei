# 請求月計算（例外登録）
class SeikyuTukiReigai < ApplicationRecord
    
    validate :check_seikyu_key_link
    validates :sisetu_nm,  presence: true
    validates :seikyu_m_su, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12, message: "は1～12の範囲で入力して下さい。" }
    validates :biko_user,  presence: true
    validates :biko_siyou, presence: true

    # 請求キーリンクの入力チェック
    def check_seikyu_key_link
        
        if seikyu_key_link.to_s == ""
            errors.add(:seikyu_key_link, "を入力してください")
        end

        if seikyu_key_link.match(/[^ -~｡-ﾟ]/)
            errors.add(:seikyu_key_link, "は半角で入力してください")
        end

        if seikyu_key_link.size != 9
            errors.add(:seikyu_key_link, "は９桁で入力してください")
        end

        if seikyu_key_link.match(/\A[0-9]+\z/)
            if seikyu_key_link.to_i == 0
                errors.add(:seikyu_key_link, "は０以上で入力してください")
            end
        else
            errors.add(:seikyu_key_link, "は数値で入力してください")
        end
    end

    class << self
        
        # テーブルの読み込み
        def table_select
            SeikyuTukiReigai.all.order(:seikyu_key_link, :id)
        end
    end
end
