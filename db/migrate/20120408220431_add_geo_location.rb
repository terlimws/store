class AddGeoLocation < ActiveRecord::Migration
  def up
    add_column :stores, :latitude, :float
    add_column :stores, :longitude, :float
  end

  def down
    remove_column :stores, :latitude
    remove_column :stores, :longitude
  end
end
