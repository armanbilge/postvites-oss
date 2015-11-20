class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :last
      t.string :first
      t.string :email
      t.string :affiliation
      t.references :conference, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
