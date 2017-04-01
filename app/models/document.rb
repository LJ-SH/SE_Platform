class Document < ActiveRecord::Base
  mount_uploader :appendix, AppendixUploader

  validates_presence_of :name, :allow_blank => false
  validates_presence_of :updated_by, :allow_blank => false
  validates_inclusion_of :doc_type, :in => DOC_TYPE

  validate :check_if_appendix_missing

  def check_if_appendix_missing
    if self.appendix.blank? || self.appendix_removal_enabled? 
      errors.add(:base, :document_appendix_missing)       
    end
  end

  def appendix_name
    self.appendix.blank?? "" : URI.decode(self.appendix.url.split("/").last.split("_UTC_").last)
  end

  def appendix_removal_enabled?
    1==self.remove_appendix.to_i 
  end  

  scope :latest_upload, ->(num) {order('updated_at desc').limit(num)}
end
