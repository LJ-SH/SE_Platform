class AddAssociationToEquipmentParts < ActiveRecord::Migration
  def change
  	add_column :equipment_parts, :iou_id, :integer	
  	add_index :equipment_parts, [:iou_id]
  end
end
