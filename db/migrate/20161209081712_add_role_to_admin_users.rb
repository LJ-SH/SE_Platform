class AddRoleToAdminUsers < ActiveRecord::Migration
  def up
  	add_column :admin_users, :role, :string, :default => "pre_sale"
  	AdminUser.reset_column_information           #force all cached information reloaded on next request
  	AdminUser.find_by_email("admin@example.com").update_attribute(:role, "admin") 
  end

  def down 	
    remove_column :admin_users, :role
  end  
end