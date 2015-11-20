class CreateAttendeesPresenters < ActiveRecord::Migration
  def change
    create_table :attendees_presenters, id: false do |t|
      t.belongs_to :attendee, index: true
      t.belongs_to :presenter, index: true
    end
  end
end
