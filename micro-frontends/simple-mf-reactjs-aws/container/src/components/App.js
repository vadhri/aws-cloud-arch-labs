import React from "react";
import Render from './Render';
import AuthRender from './Auth';

import Header from './Header';
import { BrowserRouter } from "react-router-dom";
import { createGenerateClassName, StylesProvider } from "@material-ui/styles";

const generateClassName = createGenerateClassName({
    productionPrefix: 'c-css-'
})

export default () => {
    return <StylesProvider generateClassName={generateClassName}>
        <BrowserRouter>
        <div>
            <Header/>
            <Render/>
            <AuthRender/>
        </div>
    </BrowserRouter>
    </StylesProvider>
};