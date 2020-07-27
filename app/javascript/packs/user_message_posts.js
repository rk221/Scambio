import Vue from 'vue'

window.onload = () =>{
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
}