class UsersController < ApplicationController

  def show
    @user = current_user
    @user_game_ranks = UserGameRankDecorator.decorate_collection(@user.user_game_ranks.order(:updated_at).limit(3))
    @reaction_wait_item_trade_queues = Users::ItemTradeQueueDecorator.decorate_collection(ItemTradeQueue.exist_user_enabled.includes(:item_trade, :item_trade_detail).where(item_trades: {user_id: @user.id}))
  end

  private
  def user_auth
    error_redirect(t('flash.permit_error')) unless current_user.id == params[:user_id].to_i
  end

  def error_redirect(warning_message = t('flash.default_error'))
    redirect_to user_path(current_user.id) ,warning: warning_message
  end
end
