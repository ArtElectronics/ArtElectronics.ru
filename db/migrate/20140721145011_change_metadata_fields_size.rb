class ChangeMetadataFieldsSize < ActiveRecord::Migration
  def change
    %w[ title keywords author og_url og_title og_image og_site_name ].each do |field|
      change_column_default :meta_data, field, nil
      change_column :meta_data, field, :text, limit: 10000
    end
  end
end
