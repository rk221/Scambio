class Admin::ItemGenresController < AdminController
    def index
        @item_genres = ItemGenre.all
    end
end
