const app = Vue.createApp({
    data() {
        return {
            cart:0,
            product: 'Socks',
            brand: 'Vue Mastery',
            image: './assets/images/socks_blue.jpg',
            inStock: true,
            details: ['50% cotton', '30% wool', '20% polyester'],
            variants: [
              { id: 2234, color: 'green', image: './assets/images/socks_green.jpg' },
              { id: 2235, color: 'blue', image: './assets/images/socks_blue.jpg' },
            ]
        }
    },
    methods: {
        addToCart() {
            this.cart += 1
        },
        updateImage(variantImage) {
            this.image = variantImage
        }, 
        reduceCart(){
            if(this.cart > 0){
                this.cart -= 1
            }else {
                this.clearCart()
            }
        }, 
        clearCart(){
            this.cart = 0
        }
    }
})

const cred = Vue.createApp({
    data(){
        return {
            name: "Julio Cesar Torres dos Santos", 
            id: "12easf3wef98uwhfjkbf89eyf3ekjnd", 
            dob: "1976/11/08"
        }
    }, 
    methods: {
        setPerson(){

        }, 
        clearPerson(){
            this.name = ''
            this.id = ''
            this.dob = ''
        }
    }
})
