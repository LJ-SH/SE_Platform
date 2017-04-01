ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    #div class: "blank_slate_container", id: "dashboard_default_message" do
    #  span class: "blank_slate" do
    #    span I18n.t("active_admin.dashboard_welcome.welcome")
    #    small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #  end
    #end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
    columns do 
      column do
        panel t "top_project" do 
        end
      end
      column do 
        panel t "recent_activity" do
        end
      end       
    end

    columns do
      column do
        panel t 'label.active_iou' do
          table_for Iou.latest_active(5) do
            column(i18n_helper("iou","distributor_id"))  {|iou| iou.distributor}
            column(i18n_helper("iou","start_time_of_loan")) {|iou| iou.start_time_of_loan}
            column(i18n_helper("iou","appendix")) {|iou| link_to("#{iou.appendix_name}","#{iou.appendix.url}")}
          end
        end
      end
      column do 
        panel t "label.latest_doc" do
          table_for Document.latest_upload(5) do
            column(i18n_helper("document","name"))  {|doc| doc.name}
            column(i18n_helper("document","appendix")) {|doc| link_to("#{doc.appendix_name}","#{doc.appendix.url}")}
          end          
        end
      end      
    end    
  end # content
end
