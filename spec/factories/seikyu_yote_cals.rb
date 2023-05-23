# require 'factory_bot_rails'

FactoryBot.define do
    factory :seikyu_yote_cal do
        seikyu_ym      {'1900/02'}
        seikyu_kin     {'10'}
        assen_tesuryo  {'10'}
    end
end
