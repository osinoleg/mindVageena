class CreateMindData < ActiveRecord::Migration
  def change
  end

  def up
    create_table :interpreted_data do |t|
      t.integer :attention
      t.integer :meditation
      t.timestamps
    end
  end
 
  def down
    drop_table :interpreted_data
  end

end
