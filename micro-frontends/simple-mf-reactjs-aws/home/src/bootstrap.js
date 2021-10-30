import React from 'react';
import ReactDOM from 'react-dom';
import App from './components/App';

const mount = (ele) => {
    ReactDOM.render(
        <App></App>, 
        ele
    )
}

if (process.env.NODE_ENV === 'development') {
    const ele = document.getElementById('test-home-id');
    if (ele) {
        mount(ele)
    }
}

export { mount };