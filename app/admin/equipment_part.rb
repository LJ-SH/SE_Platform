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
  #actions :all, :except => :show
  actions :index
  menu false


  #permit_params :sn_no, :equipment_id, :iou_id
end
