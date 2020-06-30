class Admin::GamesController < AdminController
    def index 
        @games = Game.all
    end

    def new
        @game = Game.new
    end
    
    def create 
        @game = Game.new(game_params)
        if @game.save
            #ItemGenreGameを追加する
            ItemGenre.find_each do |item_genre|
                ItemGenreGame.create!(item_genre_id: item_genre.id, game_id: @game.id, enable_flag: false) 
            end
            redirect_to admin_games_path, notice: t('flash.create')
        else
            render :new
        end
    end

    def edit 
        @game = Game.find(params[:id])
    end

    def update
        @game = Game.find(params[:id])

        if @game.update(game_params)
            redirect_to admin_games_path, notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy
        game = Game.find(params[:id])
        game.destroy! 

        redirect_to admin_games_path, notice: t('flash.destroy')
    end
    private

    def game_params
        params.require(:game).permit(:id, :title, :image_icon)
    end
    
end
