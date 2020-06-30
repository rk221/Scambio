class Codes::PlayStationNetworkIdsController < ApplicationController
    def new 
        @play_station_network_id = PlayStationNetworkId.new
    end

    def create 
        @play_station_network_id = PlayStationNetworkId.new(play_station_network_id_params)

        if @play_station_network_id.save
            redirect_to codes_path, notice: t('flash.regist')
        else
            render :new
        end
    end

    def edit 
        @play_station_network_id = current_user.play_station_network_id
    end

    def update 
        @play_station_network_id = current_user.play_station_network_id

        if @play_station_network_id.update(play_station_network_id_params)
            redirect_to codes_path, notice: t('flash.update')
        else
            render :edit 
        end
    end

    def destroy 
        @play_station_network_id = current_user.play_station_network_id
        
        @play_station_network_id.destroy!

        redirect_to codes_path, notice: t('flash.destroy')
    end

    private

    def play_station_network_id_params 
        params.require(:play_station_network_id).permit(:id, :psn_id).merge(user_id: current_user.id)
    end
end
