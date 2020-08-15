class Users::Codes::NintendoFriendCodesController < UsersController
    before_action :user_auth

    def new 
        @nintendo_friend_code = NintendoFriendCode.new
    end

    def create 
        @nintendo_friend_code = NintendoFriendCode.new(nintendo_friend_code_params)

        if @nintendo_friend_code.save 
            redirect_to user_codes_path(current_user), notice: t('flash.regist')
        else
            render :new
        end
    end

    def edit 
        @nintendo_friend_code = current_user.nintendo_friend_code
    end

    def update 
        @nintendo_friend_code = current_user.nintendo_friend_code

        if @nintendo_friend_code.update(nintendo_friend_code_params)
            redirect_to user_codes_path(current_user), notice: t('flash.update')
        else
            render :edit 
        end
    end

    def destroy 
        @nintendo_friend_code = current_user.nintendo_friend_code

        @nintendo_friend_code.destroy!

        redirect_to user_codes_path(current_user), notice: t('flash.destroy')
    end

    private

    def nintendo_friend_code_params
        params.require(:nintendo_friend_code).permit(:id, :friend_code).merge(user_id: current_user.id)
    end
end
