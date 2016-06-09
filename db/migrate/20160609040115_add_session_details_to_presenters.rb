class AddSessionDetailsToPresenters < ActiveRecord::Migration
  def change
    add_column :presenters, :session_day, :string
    add_column :presenters, :session_start, :string
    add_column :presenters, :session_end, :string
  end
end
