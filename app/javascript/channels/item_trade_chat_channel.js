import consumer from "./consumer"
window.onload = function(){
  window.itemTradeChat = document.getElementById('item_trade_chat');

  if (window.itemTradeChat === null){ //アイテムトレードチャットが存在するところでしか動かないように
    return;
  }

  window.chatScrollBottom = () => { // functnion(){} と同義
    window.itemTradeChat.scroll(0, itemTradeChat.scrollHeight);
  };

  window.chatScrollBottom();//初期状態でスクロールは一番下に

  var stream_name = `${window.itemTradeChat.dataset.item_trade_detail_id}`
  consumer.subscriptions.create({channel: "ItemTradeChatChannel", item_trade_detail_id: stream_name},{
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      //チャットの最後にメッセージを加える
      itemTradeChat.insertAdjacentHTML('beforeend', data['message'])

      //スクロールを一番下に
      window.chatScrollBottom();

      if(window.clickFormId == 'item_trade_chat_message_form'){// クリックされたIDがメッセージのフォームの場合
        window.itemTradeMessage.value = ''; // メッセージをクリアする
        window.clickFormId = ''; // フォームID
      }
    }
  });

  // チャットの入力フォーム
  window.itemTradeMessage = document.getElementById('item_trade_chat_message');
  // 送信ボタン
  const balloonButton = document.getElementById('item_trade_chat_message_button');

  // フォームの最大行数は10とする
  const maxLineCount = 10;
  // 改行されたかチェック。されているなら行数を変動させる関数
  const changeLineCheck = () => {
    // 現在の行数を取得
    let lineCount = (itemTradeMessage.value + '\n').match(/\r?\n/g).length;
    // 現在のフォーム行数と違う & 最大行数を超えていない 場合、フォームの行数変更
    if(lineCount != itemTradeMessage.rows &&
       lineCount <= maxLineCount){
      itemTradeMessage.rows = lineCount;
    }
  }

  // フォームに、改行、スペース、タブ以外の文字列が入力されているならfalse それ以外true
  const isMessageEmpty = () => {
    if(itemTradeMessage.value.trim().length > 0){// もじが存在する
      return false;
    }else{
      return true;
    }
  }

  // 空欄でなければボタンを有効化，空欄なら無効化する関数
  const button_activation = () => {
    if (isMessageEmpty()) {
      balloonButton.classList.add('disabled')
    } else {
      balloonButton.classList.remove('disabled')
    }
  }

  // フォームに入力した際の動作
  itemTradeMessage.addEventListener('input', () => {
    button_activation();
    changeLineCheck();
  })

  // 送信ボタンが押された時
  balloonButton.addEventListener('click', () => {
    if (isMessageEmpty()) {// もし、入力されていないなら送信取り消し
      event.preventDefault();
      return;
    }else{// 入力されている場合は、送信し、ボタンを無効化する 行数初期化
      balloonButton.classList.add('disabled');
      itemTradeMessage.rows = 1;
    }
  })
}
