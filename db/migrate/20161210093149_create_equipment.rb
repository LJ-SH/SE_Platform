class CreateEquipment < ActiveRecord::Migration
  def self.up
    create_table :equipment do |t|
      t.string :category, null: false, :default => 'Other'
      t.string :model, null: false
      t.string :desc, :bom_id
      t.integer :amount
      #t.string :sn_no
      #t.string :status
      t.timestamps
    end
  end

  def self.down
  	drop_table :equipment
  end
end