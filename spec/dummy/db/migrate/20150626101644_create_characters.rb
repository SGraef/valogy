class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.boolean :consistent

      t.timestamps
    end
  end
end
