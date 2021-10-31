import React from "react";
import { Router, Route, Switch, Link} from "react-router-dom";

import Signup from './Signup';
import Signin from './Signin';

export default ({history}) => (
  <Router history={history} >
    <Switch>
        <Route exact path="/auth/signup" component={Signup}/>
        <Route exact path="/auth/signin" component={Signin}/>
    </Switch>
  </Router>
);