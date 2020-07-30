import Vue from 'vue'

window.addEventListener('DOMContentLoaded', function() {
    new Vue({
        el: '.select-sort',
        data: {
        },
        methods:{
            onSelectedChange(e){
                e.srcElement.parentNode.parentNode.submit()
            }
        }
    })
})