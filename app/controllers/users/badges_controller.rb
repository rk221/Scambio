class Users::BadgesController < UsersController
    before_action :user_auth

    def index
        @user_badges = current_user.user_badges.all.includes({badge: :game}).order("games.title asc, badges.name")
        @wear_user_badges = @user_badges.where(wear: true).order("games.title asc, badges.name")

    end

    def edit
        @user_badges = current_user.user_badges.all.includes({badge: :game}).order("games.title asc, badges.name")
    end

    def update 
        user_badge_ids = badges_params

        unless user_badge_ids && user_badge_ids.size >= 0 && user_badge_ids.size <= UserBadge::MAX_WEAR_BADGE # サイズチェック パラメータ数が「0~最大装着数」以内ではない or 不正な文字の場合
            @user_badges = current_user.user_badges.all.includes(badge: :game).order("games.title asc, badges.name")
            flash[:danger] = t('flash.error')
            return render :edit
        end

        if UserBadge.update_wear(user_badge_ids, current_user.id) # バッジを装着する
            redirect_to action: :index, notice: t('flash.update')
        else
            @user_badges = current_user.user_badges.all.includes(badge: :game).order("games.title asc, badges.name")
            flash[:danger] = t('flash.error')
            render :edit
        end
    end

    private

    def badges_params # 付けたいuser_badge_idが格納されている配列を返す 不正なパラメータの場合はnilを返す、パラメータが存在しない場合は、バッジを全て外すためからの配列を返す
        if params[:badge_ids] # nilではない場合
            params[:badge_ids].each do |badge_id|
                return nil unless badge_id =~ /\A[0-9]+\z/
            end
            params[:badge_ids]
        else
            []
        end
    end
end
