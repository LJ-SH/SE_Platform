ActiveAdmin.register EquipmentPart do
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
  config.batch_actions = false
  config.comments = false
  belongs_to :equipment
  actions :all, :except => :show

  permit_params :sn_no, :status

  index do
    selectable_column
    #id_column
    column :sn_no
    column :status do |e|
      I18n.t("equipment_part.status.#{e.status}")
    end    
    column :created_at
    column :updated_at   
    actions
  end 	

  sidebar :parent_equipment_info, :only => [:index] do
    attributes_table_for equipment do
      row :model
      row :amount
    end
    button_to I18n.t('active_admin.actions.back_to_equipment_index'), admin_equipment_index_path, :method => 'get'
  end

  filter :sn_no
  filter :status, :as => :select, :collection => EQUIPMENT_STATUS.map{|r| [I18n.t("equipment_part.status.#{r}"),r]}

  form do |f|
    f.inputs do 
      f.input :sn_no
      f.input :status, :as => :select, :include_blank => false,
                :collection => i18n_equipment_part_status_collection_helper(EQUIPMENT_STATUS)
    end
    f.actions    
  end  

  controller do
    append_before_filter :only => [:update, :create] do
      @e = Equipment.find(params[:equipment_id])

      if @e.equipment_parts.size > @e.amount
          flash[:error] = t('equipment_part.errors.exceed_maximum_amount')
          redirect_to :action => :index
          return
      end 
    end
  end
end
