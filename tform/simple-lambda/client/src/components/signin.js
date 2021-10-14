import React from "react";
import {TextField, Button} from '@material-ui/core';
import SignIn from '../auth/signin';

import { Alert } from '@mui/material';


class SigninComponent extends React.Component {
    constructor(props, context) {
        super(props)
        
        this.state = {
            'username': '',
            'password': ''
        }   
        
        this.trySignIn = this.trySignIn.bind(this);
        this.signInCallback = this.signInCallback.bind(this);
    }

    signInCallback (error) {
        console.log(error, JSON.stringify(error));

        if (!error) {
            this.setState({
                signedIn: true
            });

            console.log('Logged in ', error);
        } else {
            this.setState({
                error: "Unable to signin."
            })
        }
    }

    trySignIn(u, p) {
        console.log(u, p);
        
        SignIn(u, p, (err) => this.signInCallback(err))
    }

    updateState(evt, param) {
        let payload = {};
        payload[param] = evt.target.value;
        this.setState(payload)
    }

    render () {
        return <div style={{ textAlign: "center" }}>
          <TextField id="susername" label="username" variant="outlined" onChange={evt => this.updateState(evt, 'username')}/><p/>
          <TextField id="spassword" type="password" label="password" variant="outlined" onChange={evt => this.updateState(evt, 'password')}/><p/>
          <Button onClick={() => this.trySignIn(this.state.username, this.state.password)}>Sign in</Button>
            {
                this.state.error && <Alert severity="error">{this.state.error}</Alert>
            }
          </div>
                
    }
}

export default SigninComponent;