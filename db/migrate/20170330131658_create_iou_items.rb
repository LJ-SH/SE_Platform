class CreateIouItems < ActiveRecord::Migration
  def change
    create_table :iou_items do |t|
      t.integer  "iou_id"
      t.integer  "equipment_id"
      t.integer  "equipment_part_id"
      t.timestamps null: false
    end
  end
end
