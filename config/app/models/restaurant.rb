class Restaurant < ApplicationRecord
  validates_presence_of :name, :address, :city
end
