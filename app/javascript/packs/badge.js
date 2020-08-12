import Vue from 'vue'

window.addEventListener('DOMContentLoaded', function() {
    new Vue({
        el: '#badge_game_id',
        data: {
        },
        methods:{
            onSelectedChange(e){
                if(e.srcElement.selectedIndex == 0){
                    document.getElementById('badge_all').checked = true
                }else{
                    document.getElementById('badge_all').checked = false
                }
            }
        }
    })
})

window.addEventListener('DOMContentLoaded', function() {
    new Vue({
        el: '#badge_all',
        data: {
        },
        methods:{
            onSelectedChange(e){
                if(e.srcElement.checked){
                    document.getElementById('badge_game_id').selectedIndex = 0
                }else if(document.getElementById('badge_game_id').selectedIndex == 0) {
                    e.srcElement.checked = true
                }
            }
        }
    })
})