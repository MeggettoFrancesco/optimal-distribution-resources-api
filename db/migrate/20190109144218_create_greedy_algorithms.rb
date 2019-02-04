class CreateGreedyAlgorithms < ActiveRecord::Migration[5.2]
  def change
    create_table :greedy_algorithms do |t|
      t.longtext :input_matrix
      t.integer :path_length
      t.integer :number_resources
      t.boolean :cycles
      t.longtext :solution

      t.timestamps
    end
  end
end
