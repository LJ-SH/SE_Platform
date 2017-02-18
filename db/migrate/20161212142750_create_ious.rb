class CreateIous < ActiveRecord::Migration
  def change
    create_table :ious do |t|
      t.references :distributor, index: { name: 'index_ious_on_distributor_id' }
      t.string :sales_name
      #t.datetime :start_time_of_loan
      #t.datetime :expected_end_time_of_loan
      t.date   :start_time_of_loan
      t.date   :expected_end_time_of_loan
      t.string :status
      t.string :contact_of_loaner
      t.string :phone_of_loaner
      t.string :approver
      t.string :appendix
      t.timestamps
    end

  end
end
