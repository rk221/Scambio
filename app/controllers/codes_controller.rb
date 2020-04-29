class CodesController < ApplicationController
    def index
       @nintendo_friend_code = Codes::NintendoFriendCodeDecorator.new(current_user.nintendo_friend_code)
    end
end
