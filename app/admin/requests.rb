ActiveAdmin.register Request do
  menu parent: 'API Requests'

  permit_params :request_type, :ip_address

  filter :request_type, as: :select, collection: Request.request_type.values
  filter :ip_address
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :request_type
    column :ip_address
    column :created_at
    column :updated_at
    actions
  end

  form do
    f.inputs do
      f.input :ip_address
    end
    f.actions
  end

  show do |r|
    attributes_table do
      row :id
      row :request_type
      Request.request_type.values.each do |t|
        row t if r.send(t).present?
      end
      row :created_at
      row :updated_at
      active_admin_comments
    end
  end
end
