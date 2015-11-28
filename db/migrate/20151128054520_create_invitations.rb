class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :attendee, index: true, foreign_key: true
      t.references :presenter, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
