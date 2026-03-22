class User < ApplicationRecord
  has_many :payments

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :time_credits, numericality: { greater_than_or_equal_to: 0 }
end
