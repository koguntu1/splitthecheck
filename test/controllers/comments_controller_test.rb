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
        assert_select 'td', "a[href='/restaurants/1']", @comment.restaurant.name
        assert_select 'td', @comment.body
      end
    end

    assert_select 'h1', 'My Votes'
    assert_select 'tbody' do
      assert_select 'tr' do
        assert_select 'td', "a[href='/restaurants/1']", assigns(:user_votes).restaurant.name
        assert_select 'td', assigns(:user_votes).upvote
        assert_select 'td', assigns(:user_votes).downvote
      end
    end
    assert_select 'h1', 'My Favorite Restaurants'

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
