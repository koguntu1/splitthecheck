class AddColumnsToRestaurnts < ActiveRecord::Migration[5.1]
  def change
    change_column :restaurants, :upvote, :integer, :default => 0
    change_column :restaurants, :downvote, :integer, :default => 0
  end
end
