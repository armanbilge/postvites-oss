class AddHashtagToConferences < ActiveRecord::Migration[5.0]
  def change
    add_column :conferences, :hashtag, :string
  end
end
