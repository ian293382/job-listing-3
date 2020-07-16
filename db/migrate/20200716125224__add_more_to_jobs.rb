class AddMoreToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :location_id , :integer
    add_column :jobs, :category_id,  :integer
    add_column :jobs, :company, :string
    add_column :jobs, :user_id, :integer
  end
end
