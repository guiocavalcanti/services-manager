class AddExternalIdToService < ActiveRecord::Migration
  def change
    add_column :services, :external_id, :integer
  end
end
