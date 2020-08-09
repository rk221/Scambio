class Admin::BadgesController < AdminController
    def index
        @badges = Badge.all
    end

    def show
        @badge = Badge.find(params[:id]).decorate
    end

    def new
        @badge = Badge.new
        @games = Game.all
    end
    
    def create
        @badge = Badge.new(badge_params)
        @games = Game.all

        if params_all # ゲーム全体作成
            if Badge.game_all_badge_create(badge_all_params)
                redirect_to action: :index, notice: t('flash.create')
            else
                flash[:danger] = t('flash.error')
                render :new 
            end
        else
            if @badge.save
                redirect_to action: :show, id: @badge.id, notice: t('flash.create')
            else
                render :new
            end
        end
    end

    def edit
        @badge = Badge.find(params[:id])
    end

    def update
        @badge = Badge.find(params[:id])

        if params_all # ゲーム全体更新
            if Badge.game_all_badge_update(@badge.name, badge_all_params)
                redirect_to action: :index, notice: t('flash.update')
            else
                flash[:notice] = t('flash.error')
                render :edit
            end
        else
            if @badge.update(badge_params)
                redirect_to action: :show, id: @badge.id, danger: t('flash.update')
            else
                render :edit
            end
        end
    end

    def destroy
        @badge = Badge.find(params[:id])
        if @badge.destroy
            redirect_to action: :index, notice: t('flash.destroy')
        else
            redirect_to action: :show, warning: t('flash.destroy_failed')
        end
    end

    private

    def badge_params
        params.require(:badge).permit(:name, :item_trade_count_condition, :rank_condition, :game_id)
    end

    def badge_all_params
        params.require(:badge).permit(:name, :item_trade_count_condition, :rank_condition)
    end

    def params_all
        params.require(:badge).permit(:all).present?
    end
end
