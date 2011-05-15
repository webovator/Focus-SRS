class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.text :card_front
      t.text :card_back
      t.integer :user_id
      t.date :review_date
      t.float :day_interval
      t.string :audio

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
