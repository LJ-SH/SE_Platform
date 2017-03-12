class Equipment < ActiveRecord::Base
  validates_presence_of :category, :allow_blank => false
  validates_presence_of :model
  validates_uniqueness_of :model, :allow_blank => false, :presence => { :case_sensitive => false }
  validates_numericality_of :amount, :greater_than_or_equal_to => 1, :only_integer => true

  attr_accessor :available_status
  #attr_accessor :pending_delete_part_num

  validate :check_if_exceed_maximum_amount

  has_many :equipment_parts, :dependent => :destroy, :inverse_of => :equipment
  accepts_nested_attributes_for :equipment_parts, :allow_destroy => true

  has_many :iou_items, :dependent => :destroy, :inverse_of => :equipment
  accepts_nested_attributes_for :iou_items, :allow_destroy => false  

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

  def check_if_exceed_maximum_amount
    #if (self.equipment_parts.size - self.pending_delete_part_num.to_i) > self.amount
    #  errors.add(:amount, :exceed_maximum_amount)
    #end
    if self.equipment_parts.reject(&:marked_for_destruction?).count > self.amount
      errors.add(:amount, :exceed_maximum_amount)
    end 
  end  
end

  #def equipment_parts_attributes=(attributes)
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