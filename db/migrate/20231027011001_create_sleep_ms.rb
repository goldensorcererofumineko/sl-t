class CreateSleepMs < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_ms do |t|
      t.datetime :start_time 
      t.datetime :set_time
      t.datetime :end_time  
      t.string :quality,       null: false 
      t.text :memo       
      t.references :user,       null: false, foreign_key: true 
      t.timestamps
    end
  end
end
