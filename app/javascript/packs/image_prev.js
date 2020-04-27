import Vue from 'vue'

var app = new Vue({
    el: '#image_app',
    data: {
        imageData: ''
    },
    methods:{
        onFileChange(e){
            const files = e.target.files;
            if(files.length > 0){
                const file = files[0];
                const reader = new FileReader();
                reader.onload = (e) => {
                    this.imageData = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }
    }
});
