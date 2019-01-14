class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :ip_address
      t.string :request_type

      t.timestamps
    end

    add_reference :greedy_algorithms, :request, foreign_key: { on_delete: :cascade }, index: true
  end
end
