class AddFavoriteResToFavorite < ActiveRecord::Migration[5.1]
  def change
    add_column :favorites, :favorite_res, :boolean, default: false
  end
end
