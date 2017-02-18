#encoding: UTF-8
ActiveAdmin.register Iou do
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
  menu :priority => 8
  permit_params :distributor_id,:sales_name,:start_time_of_loan,:expected_end_time_of_loan,
                :status, :contact_of_loaner, :phone_of_loaner, :approver, :appendix, :remove_appendix,
                :equipment_parts_attributes => [:iou_id, :status, :sn_no, :equipment_id, :id]

  index do
    selectable_column
    #id_column
    column :distributor_id
    column :start_time_of_loan
    column :status do |iou|
      I18n.t("iou.status.#{iou.status}")
    end
    column :contact
    column :appendix do |iou|
    	iou.appendix.nil?? "":link_to("#{iou.appendix_name}","#{iou.appendix.url}")
    end
    actions 
  end

  #form partial: 'form'

  form do |f|
    #f.semantic_errors *f.object.errors.keys
    f.inputs do 
      f.input :distributor_id, :as => :select, :collection => Distributor.all
      f.input :status, :as => :select, :collection => i18n_iou_status_collection_helper(IOU_STATUS), :include_blank => false
      f.input :sales_name
      f.input :start_time_of_loan
      f.input :expected_end_time_of_loan
      f.input :contact_of_loaner
      f.input :phone_of_loaner
      f.input :approver
      li do
        f.label :appendix
        f.text_node "#{f.object.appendix_name}"
        f.file_field :appendix
      end
      f.input :remove_appendix, :as => :boolean if f.object.appendix?
    end

  	f.inputs do
  	  f.has_many :equipment_parts do |p|
  	  	if p.object.new_record?
  	  	  p.input :sn_no, as: :nested_select,
  	  	          level_1: {attribute: :equipment_id, url: admin_equipment_index_path, 
  	  	             	    fields: [:category, :model], display_name: 'model'}, 
  	  	          level_2: {attribute: :id, url: admin_equipment_parts_path, 
  	  	                    fields: [:sn_no], display_name: 'sn_no', minimum_input_length: 3}
  	  	else
  	  	  p.input :equipment_id, as: :select, :collection => [p.object.equipment].map{|x| [x.model,x.id]},
  	  	          :input_html => {:disabled => true}
  	  	  p.input :sn_no, :as => :string, :input_html => {:disabled => true}
          p.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
  	  	end
  	  end
  	end

    f.actions	
  end

  show do |iou|
    attributes_table do
      row  :distributor_id
      row  :status do 
      	I18n.t("iou.status.#{iou.status}")
      end
      rows :sales_name,:start_time_of_loan,:expected_end_time_of_loan,
           :contact_of_loaner, :phone_of_loaner, :approver
      row :appendix do 
        unless iou.appendix.blank? then
          link_to "#{iou.appendix_name}", "#{iou.appendix.url}" 
        end
      end
    end

    panel t 'formtastic.titles.equipment_parts' do 
      table_for iou.equipment_parts, i18n: EquipmentPart do
      	column :equipment_id
        column :sn_no
        column :status do |e_p|
          I18n.t("equipment_part.status.#{e_p.status}")
        end
      end
    end

    active_admin_comments
  end

  filter :distributor_id, :as => :select, :collection => Distributor.all.map{|r| [r.name, r.id]}
  filter :status, :as => :select, :collection => IOU_STATUS.map{|r| [I18n.t("iou.status.#{r}"),r]}
  filter :sales_name
  filter :start_time_of_loan

  controller do
    append_before_filter :only => [:update] do
      unless params[:iou][:equipment_parts_attributes].nil?
        params[:iou][:equipment_parts_attributes].each_value do |v|
          if v["_destroy"] == "1"
          	v.merge!({"iou_id" => "", "_destroy" => "0	"})
          end
      	end
      end
    end
  end

end
