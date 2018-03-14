require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  test 'validate name, address and city' do
    restaurant = Restaurant.new
    assert_not restaurant.save

    assert_equal restaurant.errors.count, 3
    assert_equal restaurant.errors[:name][0], "can't be blank"
    assert_equal restaurant.errors[:address][0], "can't be blank"
    assert_equal restaurant.errors[:city][0], "can't be blank"
  end
end
