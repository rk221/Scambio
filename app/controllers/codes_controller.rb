class CodesController < ApplicationController
    def index 
       @nintendo_friend_code = current_user.nintendo_friend_code
    end
end
