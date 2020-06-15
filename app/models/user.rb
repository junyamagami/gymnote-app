class User < ApplicationRecord
  validates :name, {presence: true}
  validates :password, {presence: true}
  validates :gender, {presence: true}
end
