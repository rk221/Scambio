class Admin::ItemGenreGamesController < ApplicationController
    def index 
        @item_genre_games = ItemGenreGame.where(game_id: params[:game_id]).order(:id)
    end

    def enable
        @item_genre_game = ItemGenreGame.find(params[:id])
        @item_genre_game.update_attribute(:enable_flag, true)
    end
    
    def disable
        @item_genre_game = ItemGenreGame.find(params[:id])
        @item_genre_game.update_attribute(:enable_flag, false)
    end
end
