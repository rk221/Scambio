class UsersController < ApplicationController
  def show
    @user = current_user
    @user_game_ranks = UserGameRankDecorator.decorate_collection(@user.user_game_ranks.order(:updated_at).limit(3))
  end
end
