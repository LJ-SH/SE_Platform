class EquipmentPart < ActiveRecord::Base
  validates_presence_of :status, :allow_blank => false
  validates_uniqueness_of :sn_no

  belongs_to :equipment, :inverse_of => :equipment_parts

end
