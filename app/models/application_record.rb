class ApplicationRecord < ActiveRecord::Base
    
    @@debug = Rails.application.config       # デバック用

    # デバックする時
    # @@debug.pri_logger.info(hash)

    self.abstract_class = true
end
