ActiveAdmin.register Document do
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
  menu :priority => 6
  permit_params :name,:comment,:updated_by, :doc_type,
                :associated_account, :associated_solution, :appendix, :remove_appendix

  form do |f|
    f.semantic_errors
    f.inputs do 
      f.input :name, :placeholder => I18n.t('formtastic.placeholders.document.name')
      f.input :doc_type, :as => :select, :include_blank => false,
              :collection => i18n_doc_type_collection_helper(DOC_TYPE)
      f.input :associated_account
      f.input :associated_solution, :as => :select, :include_blank => false,
              :collection => i18n_equipment_category_collection_helper(PRODUCT_CATEGORY)
      f.input :comment
      li 'class' => "file input optional",'id'=> "document_appendix_input" do
        f.label :appendix
        f.text_node link_to("#{document.appendix_name}","#{document.appendix.url}")
        f.file_field :appendix
      end
      f.input :remove_appendix, :as => :boolean if f.object.appendix?
      f.input :updated_by, :input_html => {:value => f.object.updated_by || current_admin_user.email}
    end

    f.actions    
  end  

  show do |doc|
    attributes_table do
      row  :name
      row  :doc_type do 
        I18n.t("document.type.#{doc.doc_type}")
      end
      rows :associated_account,:associated_solution, :comment, :updated_by
      row :appendix do 
        doc.appendix.nil?? "":link_to("#{doc.appendix_name}", "#{doc.appendix.url}")
      end         
    end
    #active_admin_comments
  end

  index do
    selectable_column
    #id_column
    column :name
    column :doc_type do |item|
      I18n.t("document.type.#{item.doc_type}")
    end
    column :associated_solution
    #column :associated_account
    column :appendix do |doc|
      doc.appendix.nil?? "":link_to("#{doc.appendix_name}","#{doc.appendix.url}")
    end    
    column :updated_at do |item|
      item.updated_at.to_date
    end
    actions 
  end

  filter :name
  filter :doc_type, :as => :select, :collection => DOC_TYPE.map{|r| [I18n.t("document.type.#{r}"),r]}
  filter :associated_solution, :as => :select, :collection => PRODUCT_CATEGORY.map{|r| [I18n.t("equipment.category.#{r}"),r]}
  filter :updated_by
  filter :updated_at
end
