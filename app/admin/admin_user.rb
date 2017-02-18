ActiveAdmin.register AdminUser do
  config.batch_actions = false
  actions :all
  permit_params :email, :user_name, :role, :password, :password_confirmation
  config.comments = true
  menu parent: 'main_menu_setting'

  index do
    selectable_column
    #id_column
    column :user_name
    column :role do |admin_user|
      I18n.t("admin_user.role.#{admin_user.role}")
    end
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :user_name
  filter :role, :as => :select, :collection => ROLE_DEFINITION.map{|r| [I18n.t("admin_user.role.#{r}"),r]}
  filter :email
  filter :current_sign_in_at
  #filter :sign_in_count
  #filter :created_at

  form do |f|
    #f.semantic_errors *f.object.errors.keys
    #f.inputs I18n.t('formtastic.titles.admin_user_details') do
    f.inputs do
      f.input :user_name

      if current_admin_user.admin?
        @collection = ROLE_DEFINITION
      else
        #@collection = ROLE_DEFINITION.drop(1)
        @collection = [current_admin_user.role]
      end
      f.input :role, :as => :select, :collection => i18n_role_collection_helper(@collection), :include_blank => false

      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end  

  show do |admin_user|
    attributes_table do
      rows :id, :email, :user_name, :role, :sign_in_count, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip
    end

    active_admin_comments
  end

  controller do
    def destroy
      @admin_user = AdminUser.find(params[:id])
      if @admin_user.is_current_admin_user?(current_admin_user)
        flash[:error] = t('errors.messages.destroy_fails_if_current_admin_user')
        redirect_to :action => :index
        return
      end
      destroy!  
      if @admin_user.errors[:base].any?
        flash[:error] ||= []
        flash[:error].concat(@admin_user.errors[:base])
      end          
    end

    def update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end
      update! # call original destory method      
    end
  end

end
