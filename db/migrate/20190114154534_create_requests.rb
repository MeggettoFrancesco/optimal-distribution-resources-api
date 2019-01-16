class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :ip_address
      t.string :request_type

      t.timestamps
    end

    add_column :greedy_algorithms, :request_id, :string, index: true
    add_foreign_key :greedy_algorithms, :requests, on_delete: :cascade
  end
end
