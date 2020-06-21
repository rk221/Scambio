import consumer from "./consumer"
window.onload = function(){
  if (document.getElementById('item_trade_chat') === null){ //アイテムトレードチャットが存在するところでしか動かないように
    return;
  }

  class ItemTradeChat { //チャット表示部分に関するクラス
    constructor(){
      this.itemTradeChatElement = document.getElementById('item_trade_chat');
    }

    chatScrollBottom(){
      this.itemTradeChatElement.scroll(0, this.itemTradeChatElement.scrollHeight);
    }

    receivedChatScrollBottom(){ // チャットを受信した際のスクロール処理
      const baloonElements = this.itemTradeChatElement.getElementsByClassName('balloon')
      const imgElements = baloonElements[baloonElements.length - 1].getElementsByTagName('img')
      for(let i = 0; i < imgElements.length; i++){ // 画像が含まれている場合
        imgElements[i].onload = () => {
          this.chatScrollBottom(); //スクロールを一番下に
        }
      }
      this.chatScrollBottom(); //スクロールを一番下に
    }
  }

  class ItemTradeChatForm{  //チャット送信部分に関するクラス
    // フォームの最大行数は10とする
    #MaxLineCount = 10;
    constructor(){
      // チャットの入力フォーム
      this.itemTradeMessageElement = document.getElementById('item_trade_chat_message');
      // 送信ボタン
      this.balloonButton = document.getElementById('item_trade_chat_message_button');

      // フォームに入力した際の動作
      this.itemTradeMessageElement.addEventListener('input', () => {
        this.buttonActivation();//ボタン有効化
        this.changeLineCheck();//行数チェック＆変更
      })

      // 送信ボタンが押された時
      this.balloonButton.addEventListener('click', () => {
        if (this.isMessageEmpty()) {// もし、入力されていないなら送信取り消し
          event.preventDefault();
          return;
        }else{// 入力されている場合は、送信し、ボタンを無効化する 行数初期化
          this.balloonButton.classList.add('disabled');
          this.itemTradeMessageElement.rows = 1;
        }
      })
    }

    // フォームに、改行、スペース、タブ以外の文字列が入力されているならfalse それ以外true
    isMessageEmpty(){
      if(this.itemTradeMessageElement.value.trim().length > 0){// メッセージフォームに、文字が存在する
        return false;
      }else{
        return true;
      }
    }

    // 空欄でなければボタンを有効化，空欄なら無効化する関数
    buttonActivation(){
      if (this.isMessageEmpty()) {
        this.balloonButton.classList.add('disabled')
      } else {
        this.balloonButton.classList.remove('disabled')
      }
    }

    // 改行されたかチェック。されているなら行数を変動させる関数
    changeLineCheck() {
      // 現在の行数を取得
      let lineCount = (this.itemTradeMessageElement.value + '\n').match(/\r?\n/g).length;
      // 現在のフォーム行数と違う & 最大行数を超えていない 場合
      if(lineCount != this.itemTradeMessageElement.rows && lineCount <= this.#MaxLineCount){
        this.itemTradeMessageElement.rows = lineCount;// フォームの行数変更
      }
    }
  }

  const itemTradeChat = new ItemTradeChat()
  itemTradeChat.chatScrollBottom()// 読み込み時に一番下までスクロール
  const itemTradeChatForm = new ItemTradeChatForm()

  var stream_name = `${itemTradeChat.itemTradeChatElement.dataset.item_trade_detail_id}` // サブスクライブするストリーム名
  consumer.subscriptions.create({channel: "ItemTradeChatChannel", item_trade_detail_id: stream_name},{
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      itemTradeChat.itemTradeChatElement.insertAdjacentHTML('beforeend', data['message'])//チャットの最後にメッセージを加える

      itemTradeChat.receivedChatScrollBottom()// チャットを一番下までスクロール

      if(window.clickFormId == 'item_trade_chat_message_form'){// クリックされたIDがメッセージのフォームの場合
        itemTradeChatForm.itemTradeMessageElement.value = ''; // メッセージをクリアする
        window.clickFormId = ''; // フォームID
      }
    }
  });
}
