# Users/... に継承するためのコントローラ
class BaseUsersController < ApplicationController
    include Errors
    include Users
    
    before_action :user_auth

    private 

    def user_auth
        redirect_to_permit_error unless current_user.id == params[:user_id].to_i
    end
end