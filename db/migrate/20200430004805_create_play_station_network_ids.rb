class CreatePlayStationNetworkIds < ActiveRecord::Migration[6.0]
  def change
    create_table :play_station_network_ids do |t|
      t.string :psn_id, null: false, limit: 16

      t.references :user, foreign_key: true, unique:true

      t.timestamps
    end
  end
end
