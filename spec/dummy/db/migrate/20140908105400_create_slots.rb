class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.references :sheet
      t.boolean :consistent

      t.timestamps
    end
  end
end
