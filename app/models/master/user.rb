class Master::User < ApplicationRecord
    
    has_secure_password

    validates :name,    presence: true
    validates :name_id, presence: true, uniqueness: true


    

    class << self
    end
end
