class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.integer :invite_limit, default: 3
      t.integer :poster_limit, default: 5
      t.boolean :presenters_emailed, default: false
      t.boolean :attendees_emailed, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
