import faker from 'faker';

const mount = (ele) => {
    let products = '';

    for (let i = 0; i < 3; i++) {
        const name = faker.commerce.productName();
        products += `<div>${name}</div>`;
    }
    
    ele.innerHTML = products;
}

if (process.env.NODE_ENV === 'development') {
    const el = document.getElementById('test-list-products');

    // Test container for the project.
    if (el) {
        mount(el)
    }
}

export { mount };