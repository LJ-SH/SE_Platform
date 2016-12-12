class CreateCompanyProfiles < ActiveRecord::Migration
  def change
    create_table :company_profiles do |t|
      t.string   "company_name"
      t.string   "company_addr"
      t.string   "postcode"
      t.string   "company_desc"
      t.string   "contact"
      t.string   "primary_phone"
      t.string   "secondary_phone"
      t.string   "distribution_list"
      t.string   "appendix"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
      t.integer  "companyable_id"
      t.string   "companyable_type"
    end
  end
end