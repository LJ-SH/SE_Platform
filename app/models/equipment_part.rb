class EquipmentPart < ActiveRecord::Base
  has_many :iou_items, :dependent => :destroy, :inverse_of => :equipment_part
  accepts_nested_attributes_for :iou_items, :allow_destroy => false

  validates_presence_of :status, :allow_blank => false
  validates_uniqueness_of :sn_no, :scope => :equipment_id
  validates_format_of :sn_no, :with =>/\ASN-[\w]+/, :allow_blank => false, :message => :equipment_part_sn_no_invalid

  belongs_to :equipment, :inverse_of => :equipment_parts
  belongs_to :iou, :inverse_of => :equipment_parts

  attr_accessor :sn_status_comb

  def update_status(status, iou_id)
    self.update_attributes(:status => status, :iou_id => iou_id)
  end

  def sn_status_comb
  	"#{self.sn_no} ("+I18n.t("equipment_part.status.#{self.status}")+")"
  end

  scope :good_for_iou_clct, ->{where(:status => EQUIPMENT_STATUS_CLCT_READY_FOR_RSRV)}
end
