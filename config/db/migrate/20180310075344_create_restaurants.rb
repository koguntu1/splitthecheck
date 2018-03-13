class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :city
      t.integer :upvote
      t.integer :downvote

      t.timestamps
    end
  end
end
