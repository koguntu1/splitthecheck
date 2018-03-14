require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = restaurants(:one)
  end

  test "should get index" do
    get restaurants_url
    assert_response :success
  end

  test "should get new" do
    get new_restaurant_url
    assert_response :success
  end

  test "should create restaurant" do
    assert_difference('Restaurant.count') do
      post restaurants_url, params: { restaurant: { address: @restaurant.address, city: @restaurant.city, downvote: @restaurant.downvote, name: @restaurant.name, upvote: @restaurant.upvote } }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
  end

  test "should get edit" do
    get edit_restaurant_url(@restaurant)
    assert_response :success
  end

  test "should update restaurant" do
    patch restaurant_url(@restaurant), params: { restaurant: { address: @restaurant.address, city: @restaurant.city, downvote: @restaurant.downvote, name: @restaurant.name, upvote: @restaurant.upvote } }
    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should destroy restaurant" do
    assert_difference('Restaurant.count', -1) do
      delete restaurant_url(@restaurant)
    end

    assert_redirected_to restaurants_url
  end

  test "should search restaurant by name" do
    post search_path, params: { restaurant: { name: @restaurant.name } }
    assert_response :success

    assert_select 'table' do
      assert_select 'tbody' do
        assert_select 'tr', 1
        assert_select 'tr' do
          assert_select 'td', @restaurant.address
        end
      end
    end
  end

  test "should search restaurant by address" do
    post search_path, params: { restaurant: { address: @restaurant.address } }
    assert_response :success

    assert_select 'table' do
      assert_select 'tbody' do
        assert_select 'tr', 1
        assert_select 'tr' do
          assert_select 'td', @restaurant.address
        end
      end
    end
  end

  test 'search no result' do
    post search_path, params: { restaurant: { name: 'No Name Exists' } }
    assert_response :success

    assert_select 'table' do
      assert_select 'tbody' do
        assert_select 'tr', 0
      end
      end
  end
end
