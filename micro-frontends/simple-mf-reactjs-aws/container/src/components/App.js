import React, {lazy, Suspense} from "react";

const Renderlazy = lazy(() => import('./Render'))
const AuthRenderlazy = lazy(() => import('./Auth'))

// import Render from './Render';
// import AuthRender from './Auth';

import Header from './Header';
import { BrowserRouter, Switch, Route } from "react-router-dom";
import { createGenerateClassName, StylesProvider } from "@material-ui/styles";

const generateClassName = createGenerateClassName({
    productionPrefix: 'c-css-'
})

export default () => {
    return <StylesProvider generateClassName={generateClassName}>
        <BrowserRouter>
        <Suspense fallback={<div>Loading component</div>}>
            <Header/>
            <Switch>
                <Route path="/auth" component={AuthRenderlazy}/>
                <Route path="/" component={Renderlazy}/>
            </Switch>
        </Suspense>
    </BrowserRouter>
    </StylesProvider>
};