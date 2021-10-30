import faker from 'faker';

const mount = (ele) => {
    let cartSize = 3;
    if (ele) {
        ele.innerHTML = `${cartSize} items in the cart.`;
    }
}

if (process.env.NODE_ENV === 'development') {
    mount(document.getElementById('test-list-cart'))
}
export {mount};