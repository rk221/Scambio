class Codes::NintendoFriendCodesController < CodesController
    def new 
        @nintendo_friend_code = NintendoFriendCode.new
    end

    def create 
        @nintendo_friend_code = NintendoFriendCode.new(nintendo_friend_code_params)
        @nintendo_friend_code.user_id = current_user.id

        if @nintendo_friend_code.save 
            redirect_to codes_path, notice: t('flash.regist')
        else
            render :new
        end
    end

    def edit 

    end

    def update 
        
    end

    private

    def nintendo_friend_code_params
        params.require(:nintendo_friend_code).permit(:id, :friend_code, :user_id)
    end
    
end
