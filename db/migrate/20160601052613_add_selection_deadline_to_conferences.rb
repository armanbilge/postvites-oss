class AddSelectionDeadlineToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :deadline, :date
  end
end
