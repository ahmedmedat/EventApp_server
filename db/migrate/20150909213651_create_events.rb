class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column "name",:string, :limit => 100
      t.integer "date", :limit => 8 
      t.text "description",:default => "",:null =>false
      t.text "location"
      t.string "username",:limit => 50
      t.timestamps
      t.timestamps 
    end
  end
end
