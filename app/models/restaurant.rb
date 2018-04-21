class Restaurant < ApplicationRecord
  validates_presence_of :name, :address, :city
  has_many :user_votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
end
