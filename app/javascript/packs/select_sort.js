import Vue from 'vue'

new Vue({
    el: '.select-sort',
    data: {
    },
    methods:{
        onSelectedChange(e){
            e.srcElement.parentNode.submit();
        }
    }
});