class CreateCalls < ActiveRecord::Migration[7.1]
  def change
    create_table :calls do |t|
      t.string :phone_number
      t.string :status
      t.text :log

      t.timestamps
    end
  end
end
