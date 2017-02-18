ActiveAdmin.register Distributor do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  menu parent: 'main_menu_setting'  
  config.batch_actions = false
  permit_params :name,:comment,:status, 
  				:company_profile_attributes => [:companyable_id, :companyable_type,:company_name,:company_addr,
  				:postcode, :company_desc, :contact, :primary_phone, :secondary_phone, :distribution_list]

  show do |s|
    attributes_table do
  	  row :status do
  	    I18n.t("company_profile.status.#{s.status}")
  	  end
  	  row :comment
    end

    panel I18n.t('formtastic.titles.company_profile_details') do
      attributes_table_for s.company_profile do 
        rows  :company_name,:company_addr, :postcode, :company_desc, :contact, :primary_phone, :secondary_phone,
              :distribution_list
        #row   :appendix do
        #  unless s.company_profile.appendix.blank? then
        #    link_to "#{s.company_profile.appendix_name}", "#{s.company_profile.appendix.url}" 
        #  end
        #end 
      end
    end
  end

  form do |f|
  	f.inputs do
	  f.input :name
	  f.input :status, :as => :select, :include_blank => false,
                :collection => i18n_company_status_collection_helper(COMPANY_STATUS)
	  f.input :comment 
	end 
	  
  	f.inputs :company_profile_details, :for => [:company_profile, f.object.company_profile || CompanyProfile.new] do |t|	
  	  	t.inputs :company_name,:company_addr, :postcode, :company_desc, :contact, :primary_phone, :secondary_phone,
                   :distribution_list
  	end
  	f.actions
  end

  index do
    selectable_column
    #id_column
    column :name
    column :company_name do |d|
      d.company_profile.company_name unless d.company_profile.nil?
    end
    column :status do |d|
      I18n.t("company_profile.status.#{d.status}")
    end
    column :comment
    actions 
  end

  filter :name
  filter :status, :as=>:select, :collection => COMPANY_STATUS.map{|r| [I18n.t("company_profile.status.#{r}"),r]}
  filter :company_profile_company_name, :as => :string, :label => I18n.t("distributor.search_label.company_name")
  filter :company_profile_primary_phone, :as => :string, :label => I18n.t("distributor.search_label.primary_phone")

end
