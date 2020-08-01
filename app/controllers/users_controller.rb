class UsersController < ApplicationController
  include Errors
  include Users

  def show
    @user_game_ranks = current_user.user_game_ranks.order(:updated_at).limit(3).includes(:game).decorate
    @reaction_wait_item_trade_queues = ItemTradeQueue.reaction_wait_item_trade_queues(current_user.id).decorate
    @item_trade_queue_size = ItemTradeQueue.trade_under_purchases(current_user.id).size
  end

  private
  def user_auth
    permit_error_redirect unless current_user.id == params[:user_id].to_i
  end
end
