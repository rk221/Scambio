class UsersController < ApplicationController
  include Errors
  include Users

  def show
    @user_game_ranks = current_user.user_game_ranks.order(:updated_at).limit(3).includes(:game).decorate
    @reaction_wait_item_trades = ItemTrade.reaction_wait_item_trades(current_user.id).decorate
    @item_trade_queue_size = ItemTradeQueue.trade_under_purchases(current_user.id).size
  end

  private
  def user_auth
    redirect_to_permit_error unless current_user.id == params[:user_id].to_i
  end
end
