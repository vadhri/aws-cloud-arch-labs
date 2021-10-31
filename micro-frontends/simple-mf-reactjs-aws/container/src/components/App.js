import React from "react";
import Render from './Render';
import Header from './Header';
import { BrowserRouter } from "react-router-dom";

export default () => {
    return <BrowserRouter>
        <div>
            <Header/>
            <Render/>
        </div>
    </BrowserRouter>
};