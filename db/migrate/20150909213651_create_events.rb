class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column "name",:string, :limit => 100
      t.integer "date" 
      t.text "description",:default => "",:null =>false
      t.text "location",:limit =>100
      t.string "username",:limit => 50
      t.timestamps
      t.timestamps 
    end
  end
end
