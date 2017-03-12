class Iou < ActiveRecord::Base
  has_many :iou_items, :inverse_of => :iou
  accepts_nested_attributes_for :iou_items, :allow_destroy => true

  mount_uploader :appendix, AppendixUploader
  belongs_to  :distributor

  attr_accessor :contact, :last_persistent_state, :last_persistent_appendix

  validates_inclusion_of :status, :in => IOU_STATUS
  validates_presence_of :distributor_id, :allow_blank => false

  validates_format_of :phone_of_loaner, :with => /\A1[358]\d{9}$|^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?\z/,
                      :allow_blank => true

  validates_presence_of :sales_name, :allow_blank => false, :unless => Proc.new{|i| i.status == IOU_STATUS_DRAFTED}
  validates_presence_of :contact_of_loaner, :allow_blank => false, :unless => Proc.new{|i| i.status == IOU_STATUS_DRAFTED}  
  validates_presence_of :phone_of_loaner, :allow_blank => false, :unless => Proc.new{|i| i.status == IOU_STATUS_DRAFTED}
  validates_presence_of :start_time_of_loan, :allow_blank => false, :unless => Proc.new{|i| i.status == IOU_STATUS_DRAFTED}
  validates_presence_of :expected_end_time_of_loan, :allow_blank => false, :unless => Proc.new{|i| i.status == IOU_STATUS_DRAFTED}

  validates_presence_of :approver, :allow_blank => false,
                        :unless => Proc.new{|i| [IOU_STATUS_DRAFTED, IOU_STATUS_SUBMITTED].include?(i.status)}    

  validate :check_if_appendix_missing, :check_if_iou_items_missing, :check_iou_item_status

  def check_if_appendix_missing
    unless self.status == IOU_STATUS_DRAFTED
      if self.appendix.blank? || self.appendix_removal_enabled? 
        errors.add(:base, :iou_appendix_missing)       
      end
    end    
  end

  def check_if_iou_items_missing
    unless self.status == IOU_STATUS_DRAFTED
      if self.iou_items.reject(&:marked_for_destruction?).count < 1
        errors.add(:base, :iou_equipment_parts_missing)
      end
    end
  end

  def check_iou_item_status
    unless self.last_persistent_state == self.status # check if state transition occurres
      case self.status
        when IOU_STATUS_SUBMITTED
          self.iou_items.reject(&:marked_for_destruction?).each do |item|
            unless item.equipment_part.status == EQUIPMENT_STATUS_AVAILABLE
              errors.add(:base, :iou_equipment_part_not_available, :sn => item.equipment_part.sn_no)  
            end
          end
        when IOU_STATUS_ACTIVE
          self.iou_items.each do |item|
            unless (item.equipment_part.status == EQUIPMENT_STATUS_RESERVED and item.equipment_part.iou_id == self.id)
              errors.add(:base, :iou_equipment_part_wrong_state, :sn => item.equipment_part.sn_no)  
            end
          end
        else
      end
    end
  end

  before_destroy :prevent_if_active

  def prevent_if_active
    unless IOU_STATUS_DRAFTED == self.status
      errors.add(:base, :destroy_fails_if_active, :distributor => self.distributor.name)
      errors.blank?
    end    
  end

  after_initialize do
    self.last_persistent_state = self.status.blank?? IOU_STATUS_DRAFTED : self.status
    self.last_persistent_appendix = self.appendix
  end

  after_save do
    unless self.last_persistent_state == self.status    
      case self.status
        when IOU_STATUS_SUBMITTED
          self.iou_items.each do |item|
            item.equipment_part.update_status(EQUIPMENT_STATUS_RESERVED,self.id)
          end
        when IOU_STATUS_ACTIVE
          self.iou_items.each do |item|
            item.equipment_part.update_status(EQUIPMENT_STATUS_BORROWED,self.id)
          end
        else #[IOU_STATUS_DRAFTED, IOU_STATUS_CLOSED, IOU_STATUS_REJECTED]
          self.iou_items.each do |item|
            item.equipment_part.update_status(EQUIPMENT_STATUS_AVAILABLE,"")
          end
      end
    end     
  end

  def appendix_removal_enabled?
    1==self.remove_appendix.to_i 
  end

  def status_sel_collection
    case self.last_persistent_state
      when IOU_STATUS_DRAFTED
        IOU_STATUS_CLCT_AT_DRAFTED  
      when IOU_STATUS_SUBMITTED
        IOU_STATUS_CLCT_AT_SUBMITTED
      when IOU_STATUS_ACTIVE
        IOU_STATUS_CLCT_AT_ACTIVE  
      else 
        [self.last_persistent_state]
    end 
  end

  def not_draft?
    self.persisted? and self.last_persistent_state != IOU_STATUS_DRAFTED
  end

  def after_active?
    IOU_POST_SUBMITTED_STATUS_CLCT.include?(self.last_persistent_state) 
  end

  def close_state?
    IOU_CLOSE_STATUS_CLCT.include?(self.last_persistent_state)
  end

  def contact
  	"#{self.contact_of_loaner}(#{self.phone_of_loaner})"
  end

  def appendix_name
    self.appendix.blank?? "" : URI.decode(self.appendix.url.split("/").last.split("_UTC_").last)
  end 
end

  #def iou_items_attributes=(attributes)
  #  attr_values = attributes.values().uniq
  #  unless attr_values.length == attributes.length # if duplicate items
  #    c = []
  #    attr_values.each_with_index do |v,i|
  #      c << i.to_s << v
  #    end
  #    attributes = Hash[*c]
  #  end   
  #  super 
  #end 