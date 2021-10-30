import { mount as products } from 'products/ProductsIndex';
import { mount as carts } from 'cart/CartsIndex';

console.log('Container....')

products(document.getElementById('list-products'))
carts(document.getElementById('list-cart'))