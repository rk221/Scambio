class Admin::ItemGenreGamesController < ApplicationController
    def index 
        @item_genre_games = ItemGenreGame.where(game_id: params[:game_id]).includes(:item_genre).order('item_genres.name')
    end

    def enable
        @item_genre_game = ItemGenreGame.find(params[:id])
        @item_genre_game.update_attribute(:enable, true)
    end
    
    def disable
        @item_genre_game = ItemGenreGame.find(params[:id])
        @item_genre_game.update_attribute(:enable, false)
    end
end
