class Invitation < ApplicationRecord
    has_one :user
    has_one :team
end