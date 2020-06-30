class UsersController < ApplicationController
  include Errors
  include Users

  def show
    @user_game_ranks = current_user.user_game_ranks.order(:updated_at).limit(3).includes(:game).decorate
    @reaction_wait_item_trade_queues = ItemTradeQueue.exist_user_enabled.includes({item_trade: [:game, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank]}, :item_trade_detail).decorate
  end

  private
  def user_auth
    permit_error_redirect unless current_user.id == params[:user_id].to_i
  end
end
