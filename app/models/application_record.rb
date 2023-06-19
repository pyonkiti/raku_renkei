class ApplicationRecord < ActiveRecord::Base
    
    @@debug = Rails.application.config       # デバック用

    self.abstract_class = true
end
