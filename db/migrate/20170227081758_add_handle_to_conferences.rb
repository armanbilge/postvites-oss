class AddHandleToConferences < ActiveRecord::Migration[5.0]
  def change
    add_column :conferences, :handle, :string
  end
end
