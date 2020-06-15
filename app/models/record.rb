class Record < ApplicationRecord
  validates :user_id, {presence: true}
  validates :date, format: { with: /\A[0-9]+\z/}
  validates :date, length: { is: 8}

end
