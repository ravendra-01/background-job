class User < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true
  scope :avg_age, ->(gender) { where(gender: gender).average(:age).to_f.round(2) }
end
