import Vue from 'vue'

new Vue({
    el: '#fixed_phrases',
    data: {
    },
    methods:{
        onClick(e){
            const href = e.srcElement.parentNode.dataset.href
            location.href = href
        }
    }
});