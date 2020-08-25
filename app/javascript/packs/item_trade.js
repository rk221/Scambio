import Vue from 'vue'

window.addEventListener('DOMContentLoaded', function() {
    new Vue({
        el: '#item_trades',
        data: {
        },
        methods:{
            // バッジのポップオーバー
            onMouseOver(e){
                var rect = e.srcElement.getBoundingClientRect()         // イベント発生場所取得
                var data = e.srcElement.dataset                         // ポップオーバに必要なdataset取得
                // ポップオーバの親要素作成
                var popover = document.createElement('div')
                popover.setAttribute('class', 'badge-popover')
                popover.setAttribute('id', data.id)                         // 削除用IDセット
                document.body.insertAdjacentElement('beforeend', popover)   // bodyの最後に挿入 
                {// ポップオーバの中身作成
                    // ポップオーバのボディ部分
                    var body = document.createElement('div')
                    body.setAttribute('class', 'badge-body')
                    popover.insertAdjacentElement('beforeend', body)
                    {
                        // ポップオーバのヘッダー作成
                        var name = document.createElement('div')
                        name.setAttribute('class', 'badge-name')
                        name.textContent = data.name
                        body.insertAdjacentElement('beforeend', name)

                        // ポップオーバの説明作成
                        var description = document.createElement('div')
                        description.setAttribute('class', 'badge-description')
                        console.log(`${data.description}`)
                        description.innerHTML = `${data.description}`
                        body.insertAdjacentElement('beforeend', description)
                    }
                    // 吹き出しに見えるように三角形作成
                    var triangle = document.createElement('div')
                    triangle.setAttribute('class', 'badge-triangle')
                    popover.insertAdjacentElement('beforeend', triangle)
                }
                // 座標の更新（要素高さを取得したい為、挿入後）
                popover.setAttribute('style', `left: ${rect.left + window.pageXOffset}px; top: ${rect.top + window.pageYOffset - popover.offsetHeight}px;`)
            },
            onMouseLeave(e){
                document.getElementById(e.srcElement.dataset.id).remove() // 要素削除
            }
        }
    })
})