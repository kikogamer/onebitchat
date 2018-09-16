FactoryGirl.define do
    factory :invitation do
        user
        team
        joined_date { FFaker::Time }
    end
end