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
                :iou_items_attributes => [:id,:iou_id, :equipment_id, :equipment_part_id, :_destroy]

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

    panel t 'formtastic.titles.iou_items' do 
      table_for iou.iou_items, i18n: IouItem do
        column :equipment_id do |item|
          item.associated_equipment_name
        end
        column :equipment_part_id do |item|
          item.associated_equipment_part_sn
        end
      end
    end

    active_admin_comments
  end

  #form partial: 'form'
  form do |f|
    f.semantic_errors :base

    f.inputs do 
      f.input :distributor_id, :as => :select, :collection => Distributor.all, 
              :input_html => {:disabled => f.object.not_draft?}
      f.input :sales_name, :input_html => {:disabled => f.object.not_draft?}
      f.input :contact_of_loaner, :input_html => {:disabled => f.object.not_draft?}
      f.input :phone_of_loaner, :placeholder => I18n.t("formtastic.placeholders.phone_format"),
              :input_html => {:disabled => f.object.not_draft?}
      li do
        f.label :appendix
        f.text_node link_to("#{iou.appendix_name}","#{iou.appendix.url}")
        f.file_field :appendix unless f.object.not_draft?
      end
      f.input :remove_appendix, :as => :boolean if (f.object.appendix? and !f.object.not_draft?)
    end

    if f.object.not_draft?
      panel t 'formtastic.titles.iou_items' do 
        table_for iou.iou_items, i18n: IouItem do
          column :equipment_id do |item|
            item.associated_equipment_name
          end
          column :equipment_part_id do |item|
            item.associated_equipment_part_sn
          end
        end
      end
    else 
      f.inputs :name => I18n.t('formtastic.titles.iou_items') do
        f.has_many :iou_items do |item|
          item.input :equipment_part_id, as: :nested_select,
                  level_1: {attribute: :equipment_id, url: admin_equipment_index_path, 
                          fields: [:category, :model], display_name: 'model', :input_html => {:disabled => ''}}, 
                  level_2: {attribute: :equipment_part_id, url: iou_equipment_part_sel_ready_for_rsrv_collection_path, 
                            fields: [:sn_no], display_name: "sn_status_comb", minimum_input_length: 3}
          item.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
        end
      end
    end      

    f.inputs do
      f.input :start_time_of_loan, :placeholder => I18n.t("formtastic.placeholders.time_format"),
              :input_html => {:disabled => f.object.after_active?}
      f.input :expected_end_time_of_loan, 
              :placeholder => I18n.t("formtastic.placeholders.time_format"),
              :input_html => {:disabled => f.object.close_state?}
      f.input :status, :as => :select, :include_blank => false,
              :collection => i18n_iou_status_collection_helper(f.object.status_sel_collection)
      f.input :approver, :input_html => {:disabled => f.object.after_active?}      
    end

    f.actions 
  end

  #filter :distributor_id, :as => :select, :collection => Distributor.all.map{|r| [r.name, r.id]}
  filter :distributor_id, :as => :select, :collection => Distributor.all.reject{|r| r.ious.empty?}.map{|r| [r.name, r.id]}
  filter :status, :as => :select, :collection => IOU_STATUS.map{|r| [I18n.t("iou.status.#{r}"),r]}
  filter :sales_name
  filter :start_time_of_loan

  controller do
    before_filter :filter_duplicate_iou_item, :only => [:create, :update]

    def destroy
      @iou = Iou.find(permitted_params[:id])
      destroy!  
      if @iou.errors[:base].any?
        flash[:error] ||= []
        flash[:error].concat(@iou.errors[:base])
      end          
    end  

    def filter_duplicate_iou_item
      unless permitted_params[:iou][:iou_items_attributes].nil?
        attributes = permitted_params[:iou][:iou_items_attributes]
        attr_values = attributes.values().uniq
        logger.info attributes
        unless attr_values.length == attributes.length # if duplicate items
          c = []
          attr_values.each_with_index do |v,i|
            c << i.to_s << v
          end
          params[:iou][:iou_items_attributes] = Hash[*c]
        end 
      end
    end  
  end
end


    #f.inputs :name => :iou_items do
    #  f.semantic_fields_for :iou_items do |item|
    #      item.input :equipment_id, :as => :select, :include_blank => false,
    #                 :collection => {item.object.associated_equipment_name => item.object.equipment_id}, 
    #                 :input_html => {:disabled => true}
    #      item.input :equipment_part_id, :as => :select, :include_blank => false,
    #                 :collection => {item.object.associated_equipment_part_sn => item.object.equipment_part_id},
    #                 :input_html => {:disabled => true} 
    #      #item.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
    #  end
    #end
