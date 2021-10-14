import React from "react";
import {TextField, Button} from '@material-ui/core';
import {SignUp, confirmSignUp} from '../auth/signup';

import { Alert } from '@mui/material';

class SignupComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      'username': '',
      'password': '',
      'errorMessage': ''
    }
    this.trySignup = this.trySignup.bind(this);
    this.signUpCallback = this.signUpCallback.bind(this);
    this.tryConfirmPincode = this.tryConfirmPincode.bind(this);
  }

  signUpCallback(error) {
    if (!error.username) {
      this.setState({
        errorMessage: "User already exists",
        errorServerity: "error"
      })      
    } else {
      this.setState({
        errorMessage: "Succesfully signed up. Enter pin code",
        errorServerity: "success",
        pinCodeGather: true
      })     
    }
  }

   tryConfirmPincode(pin) {
    confirmSignUp(this.state.username, this.state.pincode, (error) => {
      if (!error) {
        this.setState({
          errorMessage: "Succesfully signed up. Please login. ",
          errorServerity: "success",
          pinCodeGather: false
        })    
      }    
      else{
        this.setState({
          errorMessage: "Successful registration. Please login.",
          errorServerity: "success",
        })                  
      }
    })
    }

  trySignup(u,p,e,ph) {
    SignUp(u, p, e, ph, this.signUpCallback);
  }

  updateState(evt, param) {
    let payload  = {};
    payload[param] = evt.target.value;
    this.setState(payload);
  }

  render() {
    return (<div style={{ textAlign: "center" }}>
    <TextField id="username" label="username" variant="outlined" onChange={evt => this.updateState(evt, 'username')}/><p/>
      <TextField id="email" label="email" variant="outlined" onChange={evt => this.updateState(evt, 'email')}/><p/>      
      <TextField id="password" type="password" label="password" variant="outlined" onChange={evt => this.updateState(evt, 'password')}/><p/>
      <TextField id="phno" type="phno" label="phno" variant="outlined" onChange={evt => this.updateState(evt, 'phno')}/><p/>      
      <Button onClick={() => this.trySignup(this.state.username, this.state.password, this.state.email, this.state.phno)}>Sign up</Button>
      {
        this.state.errorMessage && <Alert severity={this.state.errorServerity}>{this.state.errorMessage}</Alert>
      }
      {
        this.state.pinCodeGather &&     
        <div>
        <p/><TextField id="pincode" label="code" variant="outlined" onChange={evt => this.updateState(evt, 'pincode')}/><p/>
        <Button onClick={() => this.tryConfirmPincode(this.state.pinCode)}>Confirm</Button>
        </div>
      }
      </div>);
  } 
}

export default SignupComponent;