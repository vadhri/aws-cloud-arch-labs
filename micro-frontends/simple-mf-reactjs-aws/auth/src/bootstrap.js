import React from 'react';
import ReactDOM from 'react-dom';
import App from './components/App';

import { createMemoryHistory, createBrowserHistory } from 'history';

const mount = (ele, { onNavigate, defaultHistory }) => {
    const history = defaultHistory || createMemoryHistory();

    ReactDOM.render(
        <App history={history}></App>, 
        ele
    )

    if (onNavigate) {
        history.listen(onNavigate);
    }

    return { onNavigation : ({pathname: newPathName}) => {
        const { pathname } = history.location;

        if (pathname !== newPathName) {
            history.push(newPathName)
        }
    }};
}

if (process.env.NODE_ENV === 'development') {
    const ele = document.getElementById('test-auth-id');
    if (ele) {
        mount(ele, { defaultHistory: createBrowserHistory() });
    }
}

export { mount };