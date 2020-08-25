class AddImageIconToBadges < ActiveRecord::Migration[6.0]
  def change
    add_column :badges, :image_icon, :string
  end
end
