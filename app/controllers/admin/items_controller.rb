class Admin::ItemsController < AdminController
    def index 
        @q = Item.ransack(search_params)
        @items = @q.result(distinct: true).includes(:game, :item_genre).order(:item_genre_id, :name)
        @selectable_item_genres = ItemGenre.all
    end

    def show 
        @item = Item.find(params[:id])
        @registered_count_buy_item_trades = @item.registered_count_buy_item_trades
        @registered_count_sale_item_trades = @item.registered_count_sale_item_trades
    end

    def edit
        @item = Item.find(params[:id])
    end

    def update
        @item = Item.find(params[:id])
        if @item.update(update_unit_name_params)
          redirect_to action: :show
        else
          render :edit
        end
    end
    
    private

    def search_params 
        params[:q]&.permit(:game_title_cont, :item_genre_id_eq, :name_cont)        
    end

    def update_unit_name_params
        params.require(:item).permit(:unit_name)
    end
end
