#encoding: UTF-8  
class IouEquipmentPartSelController < ActionController::Base
  def ready_for_rsrv_collection
    e_id = params[:q][:equipment_id_eq]
    unless e_id.empty? 
      render :json => EquipmentPart.good_for_iou_clct.search(params[:q])
                      .result.map{|c| {:id => c.id, :sn_status_comb => c.sn_status_comb}}
    else
      render :json => []  
    end   
  end    
end