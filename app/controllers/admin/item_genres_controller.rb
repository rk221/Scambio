class Admin::ItemGenresController < AdminController
    def index
        @item_genres = ItemGenre.all
    end

    def new 
        @item_genre = ItemGenre.new
    end

    def create 
        @item_genre = ItemGenre.new(item_genre_params)
        if @item_genre.save 
            #ItemGenreGameを追加する
            Game.all.each do |game|
                ItemGenreGame.create(item_genre_id: @item_genre.id, game_id: game.id, enable_flag: false) 
            end
            redirect_to admin_item_genres_path, notice: t('flash.create')
        else
            render :new
        end
    end
    
    def edit 
        @item_genre = ItemGenre.find(params[:id])
    end

    def update 
        @item_genre = ItemGenre.find(params[:id])
        if @item_genre.update(item_genre_params) 
            redirect_to admin_item_genres_path, notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy 
        @item_genre = ItemGenre.find(params[:id])
        @item_genre.destroy

        redirect_to admin_item_genres_path, notice: t('flash.destroy')
    end

    private 

    def item_genre_params 
        params.require(:item_genre).permit(:id, :name, :default_unit_name)
    end
end
