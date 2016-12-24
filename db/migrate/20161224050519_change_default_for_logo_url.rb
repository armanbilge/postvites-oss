class ChangeDefaultForLogoUrl < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:conferences, :logo_url, '')
  end
end
