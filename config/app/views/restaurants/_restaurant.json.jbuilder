json.extract! restaurant, :id, :name, :address, :city, :upvote, :downvote, :created_at, :updated_at
json.url restaurant_url(restaurant, format: :json)
