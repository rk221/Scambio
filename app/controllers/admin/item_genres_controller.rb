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
            redirect_to admin_item_genres_path, notice: t('flash.new')
        else
            render :new
        end
    end

    private 

    def item_genre_params 
        params.require(:item_genre).permit(:id, :name, :default_unit_name)
    end
end
