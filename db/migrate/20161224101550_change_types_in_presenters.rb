class ChangeTypesInPresenters < ActiveRecord::Migration[5.0]
  def change # Hack to avoid casting issues
    remove_column :presenters, :session_day
    remove_column :presenters, :session_start
    remove_column :presenters, :session_end
    add_column :presenters, :session_day, :date
    add_column :presenters, :session_start, :time
    add_column :presenters, :session_end, :time
  end
end
