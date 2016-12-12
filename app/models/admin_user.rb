class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:tlogin]
  attr_accessor :tlogin

  validates :user_name, :uniqueness => true, :presence => {:case_sensitive => false}
  validates_presence_of :role, :allow_blank => false
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  before_destroy :prevent_if_last_admin

  def prevent_if_last_admin
    if self.role == ROLE_DEFINITION[0] && AdminUser.where("role=?", ROLE_DEFINITION[0]).count < 2
      errors.add(:base, :destroy_fails_if_last_admin)
      errors.blank?
    end    
  end 

  def admin?
    ROLE_DEFINITION.first(1).include?(self.role)
  end

  def is_current_admin_user?(current_admin_user)
    self.id == current_admin_user.id
  end

  private
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:tlogin)
      where(conditions).where(["lower(user_name) = :value OR lower(email) = :value", {:value => login.downcase }]).first
    else
      where(conditions).first
    end
  end   
end
