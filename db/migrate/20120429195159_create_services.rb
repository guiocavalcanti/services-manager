class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.string :type
      t.text :xquery
      t.timestamp :start_time
      t.integer :recurrence
      t.time :interval
      t.references :user

      t.timestamps
    end
  end
end
