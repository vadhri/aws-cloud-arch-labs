import React from "react";
import Render from './Render';
import Header from './Header';
import { BrowserRouter } from "react-router-dom";
import { createGenerateClassName, StylesProvider } from "@material-ui/styles";

const generateClassName = createGenerateClassName({
    productionPrefix: 'c-css-'
})

export default () => {
    return <StylesProvider>
        <BrowserRouter>
        <div>
            <Header/>
            <Render/>
        </div>
    </BrowserRouter>
    </StylesProvider>
};