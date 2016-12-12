class CompanyProfile < ActiveRecord::Base
  belongs_to :companyable, :polymorphic => true, :inverse_of => :company_profile

  validates_presence_of :company_name
  validates_uniqueness_of :company_name, :presence => { :case_sensitive => false }, :scope => :companyable_type
  validates_format_of :primary_phone, :with => /\A1[358]\d{9}$|^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?\z/, :allow_blank => true
  validates_format_of :secondary_phone, :with => /\A1[358]\d{9}$|^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?\z/, :allow_blank => true

  validate :distribution_list_check
  def distribution_list_check
    if rst = email_list_check(self.distribution_list)
      self.distribution_list = rst
    else
      errors.add(:distribution_list, :email_not_recognize)
      return
    end
  end

  def email_list_check(email_list)
    if email_list.nil?
      return ""
    else
      email_ary = email_list.strip.split(%r{[,; ]+\s*}).reject{|c| c.empty?}
      regexp = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      email_ary.each do |e|
        return false unless regexp.match(e)
      end 
      return email_ary.join(' ')
    end
  end

  #mount_uploader :appendix, AppendixUploader
  #def appendix_name
  #  self.appendix.blank?? "" : self.appendix.url.split("/").last
  #end
end