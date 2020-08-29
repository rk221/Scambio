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
                ItemGenreGame.create!(item_genre_id: item_genre.id, game_id: @game.id, enable: false) 
            end
            redirect_to action: :index, notice: t('flash.create')
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
            redirect_to action: :index, notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy
        game = Game.find(params[:id])
        game.destroy! 

        redirect_to action: :index, notice: t('flash.destroy')
    end

    # seed用csvファイルを出力（newファイルとし、直接上書きしない)
    def output_csv
        require 'csv'
        item_genre_games = ItemGenreGame.all.includes(:game, :item_genre)

        item_genre_game_csv = CSV.generate do |csv|
            column_names = %w(game_title genre_name enable)
            csv << column_names
            item_genre_games.find_each do |item_genre_game|
                column_values = [
                item_genre_game.game.title,
                item_genre_game.item_genre.name,
                item_genre_game.enable
                ]
                csv << column_values
            end
        end

        #ファイル書き込み
        File.open(Rails.root.join("db/seeds/tmp/csv/item_genre_games.csv"), "w") do |file|
            file.write(item_genre_game_csv)
        end

        p "================="
        p "CSVファイル出力完了"
        p "================="
    end

    private

    def game_params
        params.require(:game).permit(:id, :title, :image_icon)
    end
    
end
