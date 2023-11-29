class ApplicationRecord < ActiveRecord::Base
    
    require 'net/http'
    
    @@debug = Rails.application.config       # デバック用

    self.abstract_class = true
end
