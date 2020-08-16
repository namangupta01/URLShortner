class CreateTableUrl < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.string :url, null: false
      t.string :token, index: true, null: false
      t.datetime :expiry
      t.timestamps null: false
    end
  end
end
