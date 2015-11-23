class CreatePresenters < ActiveRecord::Migration
  def change
    create_table :presenters do |t|
      t.string :last
      t.string :first
      t.string :email
      t.string :affiliation
      t.string :title
      t.string :session
      t.string :location
      t.string :secret
      t.references :conference, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
