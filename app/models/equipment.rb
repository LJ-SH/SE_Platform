class Equipment < ActiveRecord::Base
  validates_presence_of :category, :allow_blank => false
  validates_presence_of :model
  validates_uniqueness_of :model, :allow_blank => false, :presence => { :case_sensitive => false }
  validates_numericality_of :amount, :greater_than_or_equal_to => 1, :only_integer => true

  attr_accessor :available_status
  attr_accessor :pending_delete_part_num

  validate :prevent_if_exceed_maximum_amount

  has_many :equipment_parts, :dependent => :destroy, :inverse_of => :equipment
  accepts_nested_attributes_for :equipment_parts, :allow_destroy => true

  def display_name
  	"#{self.model}(#{self.amount})"
  end

  def available_status
    num = 0
    unless self.equipment_parts.nil?
      num = self.equipment_parts.select{|p| p.status == EQUIPMENT_STATUS[0]}.size
    end  
  	"#{num} / #{self.amount}"
  end

  def prevent_if_exceed_maximum_amount
    if (self.equipment_parts.size - self.pending_delete_part_num.to_i) > self.amount
      errors.add(:amount, I18n.t('equipment.errors.exceed_maximum_amount'))
    end
  end
end