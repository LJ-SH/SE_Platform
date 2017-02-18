module ApplicationHelper
  def i18n_role_collection_helper(user_collection)
  	user_collection.map{|r| [I18n.t("admin_user.role.#{r}"),r]}
  end

  def i18n_equipment_category_collection_helper(equipment_collection)
  	equipment_collection.map{|r| [I18n.t("equipment.category.#{r}"),r]}
  end
  
  def i18n_equipment_part_status_collection_helper(equipment_part_status_collection)
  	equipment_part_status_collection.map{|r| [I18n.t("equipment_part.status.#{r}"),r]}
  end	

  def i18n_company_status_collection_helper(company_status_collection)
  	company_status_collection.map{|r| [I18n.t("company_profile.status.#{r}"),r]}
  end
  def i18n_iou_status_collection_helper(iou_status_collection)
    iou_status_collection.map{|r| [I18n.t("iou.status.#{r}"),r]}  
  end
end
