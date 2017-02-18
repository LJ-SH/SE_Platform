class Iou < ActiveRecord::Base
  validates_presence_of :distributor_id, :allow_blank => false
  validates_presence_of :sales_name, :allow_blank => false, :if => Proc.new{|i| i.status == IOU_STATUS_ACTIVE}
  validates_presence_of :start_time_of_loan, :allow_blank => false, :if => Proc.new{|i| i.status == IOU_STATUS_ACTIVE}
  validates_presence_of :expected_end_time_of_loan, :allow_blank => false, :if => Proc.new{|i| i.status == IOU_STATUS_ACTIVE}
  validates_inclusion_of :status, :in => IOU_STATUS
  validates_presence_of :contact_of_loaner, :allow_blank => false, :if => Proc.new{|i| i.status == IOU_STATUS_ACTIVE}  
  validates_presence_of :phone_of_loaner, :allow_blank => false, :if => Proc.new{|i| i.status == IOU_STATUS_ACTIVE}
  validates_presence_of :approver, :allow_blank => false, :if => Proc.new{|i| i.status == IOU_STATUS_ACTIVE}    
  validates_format_of :phone_of_loaner, :with => /\A1[358]\d{9}$|^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?\z/, :allow_blank => true

  has_many :equipment_parts, :inverse_of => :iou
  accepts_nested_attributes_for :equipment_parts, :allow_destroy => false

  mount_uploader :appendix, AppendixUploader
  belongs_to  :distributor

  attr_accessor :contact

  def contact
  	"#{self.contact_of_loaner}(#{self.phone_of_loaner})"
  end

  def appendix_name
    self.appendix.blank?? "" : URI.decode(self.appendix.url.split("/").last.split("_UTC_").last)
  end

  def equipment_parts_attributes=(attributes)
    attributes.each do |i,attr|
      if attr['id'].present?
        self.equipment_parts << EquipmentPart.find(attr['id'])
      end     
    end    
    super 
  end
end