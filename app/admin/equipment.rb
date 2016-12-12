ActiveAdmin.register Equipment do
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
  config.comments = true
  menu :priority => 9
  permit_params :category,:model,:desc,:bom_id,:amount

  index do
    selectable_column
    #id_column
    column :category do |e|
      I18n.t("equipment.category.#{e.category}")
    end    
    column :model
    #column :status
    column :desc
    #column :bom_id
    #column :sn_no
    #column :amount
    column :available_status    
    actions :defaults => true do |resource|
      link = link_to I18n.t('active_admin.actions.manage_parts'), admin_equipment_equipment_parts_path(:equipment_id => resource.id), :class=>"member_link"
    end
  end  

  filter :category, :as => :select, :collection => PRODUCT_CATEGORY.map{|r| [I18n.t("equipment.category.#{r}"),r]}
  filter :model 
  filter :desc
  filter :bom_id

  form do |f|
    f.inputs do 
      f.input :category, :as => :select, :include_blank => false,
                :collection => i18n_equipment_category_collection_helper(PRODUCT_CATEGORY)
      f.input :model
      f.input :desc
      f.input :amount
      f.input :bom_id
    end
    f.actions    
  end

  show do |e|
    attributes_table do
      rows :category, :model, :desc, :bom_id, :amount
    end

    panel t 'formtastic.titles.equipment_parts' do 
      table_for e.equipment_parts, i18n: EquipmentPart do
        column :sn_no
        column :status do |e_p|
          I18n.t("equipment_part.status.#{e_p.status}")
        end
      end
    end
  end

end


