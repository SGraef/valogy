class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.references :user
      t.boolean :consistent
      

      t.timestamps
    end
  end
end
