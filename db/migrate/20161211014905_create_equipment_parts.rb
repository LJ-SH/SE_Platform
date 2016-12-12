class CreateEquipmentParts < ActiveRecord::Migration
  def change
    create_table :equipment_parts do |t|
      t.references :equipment
      t.string :sn_no
      t.string :status
      t.timestamps
    end
  end
end
