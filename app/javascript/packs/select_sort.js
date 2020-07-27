import Vue from 'vue'

window.onload = () =>{
    new Vue({
        el: '.select-sort',
        data: {
        },
        methods:{
            onSelectedChange(e){
                e.srcElement.parentNode.parentNode.submit();
            }
        }
    });
}