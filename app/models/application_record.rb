class ApplicationRecord < ActiveRecord::Base
    
    require 'net/http'
    require 'fileutils'
    
    # 斡旋手数料のテスト用
    require 'rubyXL/convenience_methods'

    @@debug = Rails.application.config       # デバック用

    self.abstract_class = true
end
