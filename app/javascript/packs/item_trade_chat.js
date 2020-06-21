import Vue from 'vue'

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

new Vue({
    el: '#item_trade_chat_code_form',
    data: {
    },
    methods:{
        onChange(e){
            document.getElementById('item_trade_chat_code_form_submit').click()// 画像を送信
        }
    }
});

new Vue({
    el: '#item_trade_chat_message_form',
    data: {
    },
    methods:{
        onClick(){
            window.clickFormId = 'item_trade_chat_message_form'
        }
    }
});