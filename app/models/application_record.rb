class ApplicationRecord < ActiveRecord::Base
    
    require 'net/http'
    require 'fileutils'
    require 'rubyXL/convenience_methods'    # 斡旋手数料の請求書でExcel作成で使用

    @@debug = Rails.application.config       # デバック用

    self.abstract_class = true
end
