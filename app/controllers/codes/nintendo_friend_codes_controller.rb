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
        @nintendo_friend_code = NintendoFriendCode.find(params[:id])
    end

    def update 
        @nintendo_friend_code = NintendoFriendCode.find(params[:id])

        if @nintendo_friend_code.update(nintendo_friend_code_params)
            redirect_to codes_path, notice: t('flash.update')
        else
            render :edit 
        end
    end

    def destroy 
        @nintendo_friend_code = NintendoFriendCode.find(params[:id])
        @nintendo_friend_code.destroy

        redirect_to codes_path, notice: t('flash.destroy')
    end

    private

    def nintendo_friend_code_params
        params.require(:nintendo_friend_code).permit(:id, :friend_code, :user_id)
    end
    
end
