import Vue from 'vue'
// users/shared/_item_trade_chatにおけるjavascript 主に、チャット送信に関するもの
// 画像投稿
window.onload = () =>{
    new Vue({
        el: '#item_trade_chat_image_form',
        data: {
        },
        methods:{
            onFileChange(e){
                document.getElementById('item_trade_chat_image_form_submit').click()// 画像を送信
                e.srcElement.value = '' // ファイルの内容を消去
            }
        }
    });
    // コード送信
    new Vue({
        el: '#item_trade_chat_code_form',
        data: {
        },
        methods:{
            onChange(e){
                document.getElementById('item_trade_chat_code_form_submit').click()// メッセージを送信
                e.srcElement.checked = false
            }
        }
    });
    // 定形文送信
    new Vue({
        el: '#item_trade_chat_fixed_phrase_form',
        data: {
        },
        methods:{
            onChange(e){
                document.getElementById('item_trade_chat_fixed_phrase_form_submit').click()// メッセージを送信
                e.srcElement.checked = false
            }
        }
    });
    // チャットメッセージ送信
    new Vue({
        el: '#item_trade_chat_message_form',
        data: {
        },
        methods:{
            onClick(){
                window.clickFormId = 'item_trade_chat_message_form'//チャットをクリックしたことを保持（channel.jsにおいて、受信時、記述内容を消すため）
            }
        }
    });
}