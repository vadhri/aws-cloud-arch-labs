import { Auth } from 'aws-amplify';

async function SignIn(username, password, callback) {
    try {
        const user = await Auth.signIn(username, password);
        callback(user)
    } catch (error) {
        console.log('error signing in', error);
        callback(error)
    }
}

export default SignIn;