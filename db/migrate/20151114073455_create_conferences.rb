class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.integer :invite_limit
      t.integer :poster_limit
      t.datetime :deadline
      t.boolean :open
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
