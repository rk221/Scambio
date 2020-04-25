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
            redirect_to admin_games_path, notice: 'ゲームを新規登録しました'
        else
            render :new
        end
    end

    private

    def game_params
        params.require(:game).permit(:id, :title, :image_icon)
    end
    
end
