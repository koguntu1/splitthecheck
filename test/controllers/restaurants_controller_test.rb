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
    sign_in users(:one)
    get new_restaurant_url
    assert_response :success
  end

  test "should create restaurant" do
    sign_in users(:one)
    assert_difference('Restaurant.count') do
      post restaurants_url, params: { restaurant: { address: @restaurant.address, city: @restaurant.city, name: @restaurant.name } }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:one)
    get edit_restaurant_url(@restaurant)
    assert_response :success
  end

  test "should update restaurant" do
    sign_in users(:one)
    patch restaurant_url(@restaurant), params: { restaurant: { address: @restaurant.address, city: @restaurant.city, name: @restaurant.name } }
    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should destroy restaurant" do
    sign_in users(:one)
    assert_difference('UserVote.count', -1) do
      assert_difference('Restaurant.count', -1) do
        delete restaurant_url(@restaurant)
      end
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

  test 'should verify upvote and user votes count increment' do
    sign_in users(:one)
    UserVote.destroy_all
    assert_equal @restaurant.upvote, 1
    assert_difference('UserVote.count', 1) do
      patch restaurant_url(@restaurant), params: { restaurant: { upvote: @restaurant.upvote + 1, id: @restaurant.id}, format: :json }
      assert_response :success
    end
    assert_equal UserVote.last.user, users(:one)
    assert_equal UserVote.last.upvote, 1
    assert_equal UserVote.last.downvote, 0

    @restaurant.reload
    assert_equal @restaurant.upvote, 2
  end

  test 'should verify restaurant page permission' do
    get new_restaurant_url
    assert_redirected_to new_user_session_url

    get edit_restaurant_url(@restaurant)
    assert_redirected_to new_user_session_url

    assert_no_difference('Restaurant.count') do
      delete restaurant_url(@restaurant)
    end
    assert_redirected_to new_user_session_url
  end

  test 'should verify restaurant index page' do
    sign_in users(:one)
    get restaurants_url
    assert_response :success

    assert_select 'table > tbody' do
      assert_select 'tr', 2
      assert_select 'tr' do
        assert_select 'td', @restaurant.name
        assert_select 'td', @restaurant.city
        assert_select "a[href='/vote_history?id=#{@restaurant.id}']", text: 'History'
        assert_select "a[href='/restaurants/#{@restaurant.id}']", text: 'Show'
      end
    end
  end

  test 'should verify user votes' do
    user_vote = user_votes(:one)
    get vote_history_url, params: {id: @restaurant.id}
    assert_select 'table > tbody' do
      assert_select 'tr', 1
      assert_select 'td', user_vote.user.email
      assert_select 'td', user_vote.restaurant.name
    end
  end
end
