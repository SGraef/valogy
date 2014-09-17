class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.references :sheet

      t.timestamps
    end
  end
end
