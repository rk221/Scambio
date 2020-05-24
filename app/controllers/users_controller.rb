class UsersController < ApplicationController
  def show
    @user = current_user
    @item_trades = ItemTradeDecorator.decorate_collection(@user.item_trades.enabled)
  end
end
