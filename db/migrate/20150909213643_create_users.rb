class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column "username",:string, :limit => 50
      t.string "email",:default => "",:null =>false
      t.string "password",:limit =>40
      t.timestamps
      t.timestamps
    end
  end
end
