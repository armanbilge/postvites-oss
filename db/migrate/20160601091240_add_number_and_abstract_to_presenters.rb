class AddNumberAndAbstractToPresenters < ActiveRecord::Migration
  def change
    add_column :presenters, :number, :string
    add_column :presenters, :abstract, :text
  end
end
