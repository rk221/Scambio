class Admin::GamesController < AdminController
    def index 
        @games = Game.all
    end
end
