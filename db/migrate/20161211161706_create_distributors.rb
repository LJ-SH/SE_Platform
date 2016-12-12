class CreateDistributors < ActiveRecord::Migration
  def change
    create_table :distributors, :primary_key => "d_id", :force => true do |t|
	  t.string   "name"
	  t.string   "status"
	  t.string   "type"
	  t.string   "comment"
	  t.datetime "created_at", :null => false
	  t.datetime "updated_at", :null => false
    end
  end
end