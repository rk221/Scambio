class Users::CodesController < BaseUsersController
    def index
       @nintendo_friend_code = current_user.nintendo_friend_code&.decorate
       
       @play_station_network_id = current_user.play_station_network_id
    end
end
