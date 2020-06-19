class CodesController < ApplicationController
    def index
       @nintendo_friend_code = current_user.nintendo_friend_code
       @nintendo_friend_code = @nintendo_friend_code.decorate if @nintendo_friend_code.present?
       
       @play_station_network_id = current_user.play_station_network_id
    end
end
