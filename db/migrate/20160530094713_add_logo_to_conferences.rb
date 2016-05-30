class AddLogoToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :logo_url, :string
  end
end
