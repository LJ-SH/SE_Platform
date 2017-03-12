class IouItem < ActiveRecord::Base
  belongs_to :iou, :inverse_of => :iou_items
  belongs_to :equipment_part, :inverse_of => :iou_items
  belongs_to :equipment, :inverse_of => :iou_items

  validates_uniqueness_of :equipment_part_id, :scope => [:iou_id, :equipment_id], :message => :iou_item_duplicate

  def associated_equipment_name 
  	self.equipment.model unless self.equipment_id.nil?
  end

  def associated_equipment_part_sn
  	self.equipment_part.sn_status_comb unless self.equipment_part_id.nil?
  end	
end
