class Admin::ItemGenreGamesController < ApplicationController
    def index 
        @item_genre_games = ItemGenreGame.where(game_id: params[:game_id])
    end
end
