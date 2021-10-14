import { Auth } from 'aws-amplify';

export async function SignUp(username, password, email, phone_number, callback) {
    try {
        const { user, userConfirmed, userSub } = await Auth.signUp({
            username,
            password,
            attributes: {
                email,          
                phone_number
            }
        });
        console.log(user);
        callback(user, userConfirmed, userSub);
    } catch (error) {
        callback(JSON.stringify(error));
    }
}

export async function confirmSignUp(username, code, callback) {
    try {
      await Auth.confirmSignUp(username, code);
      callback()
    } catch (error) {
        console.log('error confirming sign up', error);
        callback(error);
    }
}
