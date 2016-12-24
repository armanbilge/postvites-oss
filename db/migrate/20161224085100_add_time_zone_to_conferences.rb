class AddTimeZoneToConferences < ActiveRecord::Migration[5.0]
  def change
    add_column :conferences, :time_zone, :string, default: 'UTC'
  end
end
