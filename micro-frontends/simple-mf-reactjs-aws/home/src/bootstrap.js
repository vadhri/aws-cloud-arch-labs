import React from 'react';
import ReactDOM from 'react-dom';
import App from './components/App';
import { createMemoryHistory } from 'history';

const mount = (ele, { onNavigate, defaultHistory, initialPath }) => {

    const history = createMemoryHistory({
        initialEntries: [initialPath]
    });

    ReactDOM.render(
        <App history={history}></App>, 
        ele
    )

    if (onNavigate) {
        history.listen(onNavigate);
    }

    return { onNavigation : ({pathname: newPathName}) => {
        console.log('Container -> App (onNavigation)', newPathName, pathname);
        const { pathname } = history.location;

        if (pathname !== newPathName) {
            history.push(newPathName)
        }
    }};
}

if (process.env.NODE_ENV === 'development') {
    const ele = document.getElementById('test-home-id');
    if (ele) {
        mount(ele, {})
    }
}

export { mount };