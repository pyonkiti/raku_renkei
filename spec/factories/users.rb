FactoryBot.define do
    factory :user, class: Master::User do
        name     {'あ'}
        name_id {'aaa'}
        password              { 'aaa' }
        password_confirmation { 'aaa' }
        admin { 'true' }
    end
end
