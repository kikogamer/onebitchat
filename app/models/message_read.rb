class MessageRead < ApplicationRecord
  belongs_to :message, :dependent => :destroy
  belongs_to :user
end
