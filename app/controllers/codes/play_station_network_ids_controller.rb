class Codes::PlayStationNetworkIdsController < ApplicationController
    def new 
        @play_station_network_id = PlayStationNetworkId.new
    end

    def create 
        @play_station_network_id = PlayStationNetworkId.new(play_station_network_id_params)
        @play_station_network_id.user_id = current_user.id

        if @play_station_network_id.save
            redirect_to codes_path, notice: t('flash.regist')
        else
            render :new
        end
    end

    def edit 

    end

    def update 

    end

    def destroy 
        
    end

    def play_station_network_id_params 
        params.require(:play_station_network_id).permit(:id, :psn_id, :user_id)
    end
end
