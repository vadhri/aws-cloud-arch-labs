import React from "react";
import { Switch,Route, Router } from "react-router-dom";
import { createGenerateClassName, StylesProvider } from "@material-ui/styles";

import Landing from './Landing';
import Pricing from './Pricing';

const generateClassName = createGenerateClassName({
    productionPrefix: 'home-css-'
})

export default ({history}) => {
    return <div>
        <StylesProvider generateClassName={generateClassName}>
            <Router history={history}>
                <Switch>
                    <Route exact path="/pricing" component={Pricing}></Route>
                    <Route exact path="/" component={Landing}></Route>
                </Switch>
            </Router>
        </StylesProvider>
    </div>
}