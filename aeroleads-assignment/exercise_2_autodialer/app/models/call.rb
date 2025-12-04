class Call < ApplicationRecord
  validates :phone_number, presence: true
  
  # Statuses: pending, initiated, completed, failed
end
