class CreateCharacterItemJoinTable < ActiveRecord::Migration
  def change
    create_table :characters_items do |t|
      t.references :character
      t.references :item

      t.timestamps
    end
  end
end
