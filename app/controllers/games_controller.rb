class GamesController < ApplicationController
    def index 
        @q = Game.ransack(params[:q])
        @games = @q.result(distinct: true)
    end
end
