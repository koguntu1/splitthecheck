class Restaurant < ApplicationRecord
  validates_presence_of :name, :address, :city
  has_many :user_votes, dependent: :destroy
end
