class Equipment < ActiveRecord::Base
  validates_presence_of :category, :allow_blank => false
  validates_uniqueness_of :model, :allow_blank => false
  validates_numericality_of :amount, :greater_than_or_equal_to => 1, :only_integer => true

  attr_accessor :available_status

  has_many :equipment_parts, :dependent => :destroy, :inverse_of => :equipment
  accepts_nested_attributes_for :equipment_parts, :allow_destroy => true

  def display_name
  	"#{self.model}(#{self.amount})"
  end

  def available_status
  	num = 0
  	for e_p in self.equipment_parts do 
  	  num = num+1 if EQUIPMENT_STATUS[0] == e_p.status 
  	end
  	"#{self.amount}(#{num})"
  end
end