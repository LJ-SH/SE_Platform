class Distributor < ActiveRecord::Base
  #attr_accessor :appendix, :file

  has_one :company_profile, :as => :companyable, :dependent => :destroy, :inverse_of => :companyable
  accepts_nested_attributes_for :company_profile, :allow_destroy => true

  validates :name, :uniqueness => true,  :presence => { :case_sensitive => false }
  validates_inclusion_of :status, :in => COMPANY_STATUS
end
