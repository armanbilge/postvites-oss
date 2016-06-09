class CreateAttendeeKeywords < ActiveRecord::Migration
  def change
    create_table :attendee_keywords do |t|
      t.references :attendee, index: true, foreign_key: true
      t.references :keyword, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
