class EquipmentPart < ActiveRecord::Base
  validates_presence_of :status, :allow_blank => false
  validates_uniqueness_of :sn_no, :scope => :equipment_id
  validates_format_of :sn_no, :with =>/\ASN-[\w]+/, :allow_blank => false, :message => :equipment_part_sn_no_invalid

  belongs_to :equipment, :inverse_of => :equipment_parts
  belongs_to :iou, :inverse_of => :equipment_parts

  attr_accessor :sn_no_status_comb

  def sn_on_status_comb
  	"#{self.sn_no}"+I18n.t("iou.status.#{self.status}")
  end

end
