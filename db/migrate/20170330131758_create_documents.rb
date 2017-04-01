class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.string :updated_by
      t.string :comment
      t.string :doc_type
      t.string :associated_account
      t.string :associated_solution
      t.string :appendix      
      t.timestamps null: false
    end
  end
end
