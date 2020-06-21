import Vue from 'vue'

new Vue({
    el: '#user_message_posts',
    data: {
    },
    methods:{
        onClick(e){
            const href = e.srcElement.parentNode.dataset.href
            location.href = href
        }
    }
});
