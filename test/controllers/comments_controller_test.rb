require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @comment = comments(:one)
  end

  test "should get summary page" do
    get user_summary_url
    assert_response :success

    assert_equal assigns(:comments).length, 1
    assert_equal assigns(:user_votes).length, 1
    assert_equal assigns(:favorite_restaurants).length, 1

    assert_select 'h1', 'My Comments'
    assert_select 'tbody' do
      assert_select 'tr' do
        assert_select 'td', @comment.restaurant.name
        assert_select 'td', @comment.body
      end
    end

    assert_select 'h1', 'My Votes'
    assert_select 'tbody' do
      assert_select 'tr' do
        assert_select 'td', @comment.restaurant.name
        assert_select 'td', "#{assigns(:user_votes)[0].upvote}"
        assert_select 'td', "#{assigns(:user_votes)[0].downvote}"
      end
    end
    assert_select 'h1', 'My Favorite Restaurants'
    assert_select 'ul' do
      assert_select 'li', assigns(:favorite_restaurants)[0].restaurant.name
    end
  end

  test 'should verify summary page is private to user' do
    get user_summary_url
    assert_response :success

    assert_equal assigns(:comments).length, 1
    assert_equal assigns(:comments)[0].body, comments(:one).body
    assert_equal assigns(:favorite_restaurants).length, 1
    assert_equal assigns(:favorite_restaurants)[0].restaurant.name, restaurants(:one).name

    sign_out users(:one)
    sign_in users(:two)

    get user_summary_url
    assert_response :success

    assert_equal assigns(:comments).length, 1
    assert_equal assigns(:comments)[0].body, comments(:two).body
    assert_equal assigns(:favorite_restaurants).length, 1
    assert_equal assigns(:favorite_restaurants)[0].restaurant.name, restaurants(:two).name
  end

  test 'should verify user cannot get summary page withouy login' do
    sign_out users(:one)
    get user_summary_url
    assert_response :redirect
  end

  test "should get new" do
    get new_comment_url
    assert_response :success
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post comments_url, params: { comment: { body: @comment.body, restaurant_id: @comment.restaurant_id, user_id: @comment.user_id } }
    end
    assert_redirected_to restaurant_url(Comment.last.restaurant)
  end

  test "should show comment" do
    get comment_url(@comment)
    assert_response :success
  end
end
