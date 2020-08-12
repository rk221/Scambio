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

        unless user_badge_ids && user_badge_ids.size >= 1 && user_badge_ids.size <= 3 # サイズチェック パラメータ数が1~3以内ではない or 不正な文字の場合
            @user_badges = current_user.user_badges.all.includes({badge: :game}).order("games.title asc, badges.name")
            flash[:danger] = t('flash.error')
            return render :edit
        end

        if UserBadge.update_wear(user_badge_ids, current_user.id) # バッジを装着する
            redirect_to actin: :index, notice: t('flash.update')
        else
            @user_badges = current_user.user_badges.all.includes({badge: :game}).order("games.title asc, badges.name")
            flash[:danger] = t('flash.error')
            render :edit
        end
    end

    private

    def badges_params # 付けたいuser_badge_idが格納されている配列を返す
        if params[:badge_ids] # nilではない場合
            params[:badge_ids].each do |badge_id|
                return nil unless badge_id =~ /\A[0-9]+\z/
            end
            params[:badge_ids]
        else
            nil
        end
    end
end
