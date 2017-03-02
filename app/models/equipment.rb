class Equipment < ActiveRecord::Base
  validates_presence_of :category, :allow_blank => false
  validates_presence_of :model
  validates_uniqueness_of :model, :allow_blank => false, :presence => { :case_sensitive => false }
  validates_numericality_of :amount, :greater_than_or_equal_to => 1, :only_integer => true

  attr_accessor :available_status
  #attr_accessor :pending_delete_part_num

  validate :prevent_if_exceed_maximum_amount

  has_many :equipment_parts, :dependent => :destroy, :inverse_of => :equipment
  accepts_nested_attributes_for :equipment_parts, :allow_destroy => true

  before_destroy :prevent_if_any_active_ious

  def prevent_if_any_active_ious
    if !self.ious.nil? && self.ious.select{|k,v| v["status"] == IOU_STATUS[3]}
      errors.add(:base, :destroy_fails_if_any_active_iou)
      errors.blank?
    end 
  end

  def display_name
  	"#{self.model}(#{self.amount})"
  end

  def available_status
    num = 0
    unless self.equipment_parts.nil?
      num = self.equipment_parts.select{|p| p.status == EQUIPMENT_STATUS[0]}.size
    end  
  	"#{num} / #{self.equipment_parts.size}"
  end

  def prevent_if_exceed_maximum_amount
    #if (self.equipment_parts.size - self.pending_delete_part_num.to_i) > self.amount
    #  errors.add(:amount, :exceed_maximum_amount)
    #end
    if self.equipment_parts.reject(&:marked_for_destruction?).count > self.amount
      errors.add(:amount, :exceed_maximum_amount)
    end 
  end
end