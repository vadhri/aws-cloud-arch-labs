import logo from './logo.svg';
import './App.css';

import SignupComponent from './components/signup';
import SigninComponent from './components/signin';

import { COGNITO } from "./config/cognito";
import Amplify from "aws-amplify";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import Card from "@material-ui/core/Card";

Amplify.configure({
  aws_cognito_region: COGNITO.REGION,
  aws_user_pools_id: COGNITO.USER_POOL_ID,
  aws_user_pools_web_client_id: COGNITO.APP_CLIENT_ID,
});

function App() {
  return (
    <Router>
      <Switch>
      <Route path="/signup">
        <Card style={{ width: 500, margin: "100px auto", padding: "40px" }}>
          <SignupComponent/>
          </Card>      
      </Route>
      <Route path="/signin">
        <Card style={{ width: 500, margin: "100px auto", padding: "40px" }}>
          <SigninComponent/>
          </Card>      
      </Route>      
      </Switch>
    </Router>
  );
}

export default App;
