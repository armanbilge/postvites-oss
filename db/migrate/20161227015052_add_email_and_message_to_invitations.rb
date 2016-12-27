class AddEmailAndMessageToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :include_email, :boolean
    add_column :invitations, :message, :text
  end
end
