ActiveAdmin.register GreedyAlgorithm do
  menu parent: 'API Requests'
  actions :all, except: :edit

  filter :path_length
  filter :number_resources
  filter :cycles
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :input_matrix do |my_resource|
      truncate(my_resource.input_matrix, length: 100)
    end
    column :path_length
    column :number_resources
    column :cycles
    column :solution
    column :request
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :input_matrix
      row :path_length
      row :number_resources
      row :cycles
      row :solution
      row :request
      row :created_at
      row :updated_at
      active_admin_comments
    end
  end
end
