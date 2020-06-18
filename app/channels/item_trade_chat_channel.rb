class ItemTradeChatChannel < ApplicationCable::Channel
  def subscribed # チャットに接続した時に呼び出される関数。つまり、取引中のアイテムトレード詳細に接続した際に呼ばれる？
    # stream_from "some_channel"
    stream_from "item_trade_chat:#{params[:item_trade_detail_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
