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
  permit_params :category,:model,:desc,:bom_id,:amount, :equipment_parts_attributes => [:_destroy, :id,:sn_no, :status]

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
    actions 
    #actions :defaults => true do |resource|
    #  link = link_to I18n.t('active_admin.actions.manage_parts'), admin_equipment_equipment_parts_path(:equipment_id => resource.id), :class=>"member_link"
    #end
  end  

  filter :category, :as => :select, :collection => PRODUCT_CATEGORY.map{|r| [I18n.t("equipment.category.#{r}"),r]}
  filter :model 
  filter :desc
  filter :bom_id
  filter :equipment_parts_status, :as => :select,
         :collection => EQUIPMENT_STATUS.map{|r| [I18n.t("equipment_part.status.#{r}"),r]}
  filter :equipment_parts_sn_no, :as => :string 

  form do |f|
    #f.semantic_errors *f.object.errors.keys
    f.inputs do 
      f.input :category, :as => :select, :include_blank => false,
                :collection => i18n_equipment_category_collection_helper(PRODUCT_CATEGORY)
      f.input :model
      f.input :desc
      f.input :amount
      f.input :bom_id
      f.input :pending_delete_part_num, :as => :hidden
    end
    f.inputs do
      f.has_many :equipment_parts do |t|
        t.input :sn_no
        t.input :status, :as => :select, :include_blank => false,
                :collection => i18n_equipment_part_status_collection_helper(EQUIPMENT_STATUS)
        t.input :_destroy, :as => :boolean, :required => false, :label => 'Remove' unless t.object.new_record?
      end
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

  controller do
    def apply_filtering(chain)
     @search = chain.ransack clean_search_params
     @search.result(distinct: true)
    end

    append_before_filter :only => [:create, :update] do
      unless params[:equipment][:equipment_parts_attributes].nil?
        destroy_ep = params[:equipment][:equipment_parts_attributes].select{|k,v| v["_destroy"] == "1"}
        params[:equipment][:pending_delete_part_num] = destroy_ep.size
      end
    end
    #append_before_filter :only => [:update, :create] do
    #  if params[:equipment][:equipment_parts_attributes].nil?
    #    part_num = 0
    #  else
    #    part_num = params[:equipment][:equipment_parts_attributes].size
    #  end
    #  if part_num > params[:equipment][:amount].to_i
    #      flash[:error] = t('equipment.errors.exceed_maximum_amount')
    #      redirect_to(:back)
    #      return
    #  end 
    #end    
  end
end


