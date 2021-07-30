import classes from './Login2.module.css';
import Logo from '../icons/Logo.PNG';
import {useRef} from 'react';
import {useState} from 'react';
import {Link} from 'react-router-dom';
import { withRouter } from 'react-router-dom';

function Login2(props)
{
    const emailRef = useRef();
    const passRef = useRef();
    const [errorMsg, setMsg] = useState("");
    
    async function loginHandler(event)
    {
        event.preventDefault();
        const email = emailRef.current.value;
        const password = passRef.current.value;

        const signinData = 
        {
            email: email,
            password: password
        }

        var js = JSON.stringify(signinData);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/login', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }

        if (res.error != 'Login/Password incorrect'){
            var user = {
                Email: res.email,
                FirstName: res.firstName,
                LastName: res.lastName,
                Phone: res.phone,
                CompanyCode: res.companyCode,
                Flag: res.flag,
                Verified: res.verified,
            }
            localStorage.setItem('user_data', JSON.stringify(user));
            if (!user.Verified) {
                props.history.push('/verify');
            }
            props.history.push('/jobs-w');
        }
    }

    return (
        <div className={classes.logcard}>
            <div className={classes.col}>
                <h2 className={classes.h2}>SIGN IN</h2>
                <form onSubmit={loginHandler}>
                    <div>
                        <label className={classes.label}>Email</label> <br></br>
                        <input type='email' className={classes.input} required id='email' ref={emailRef}/>
                    </div>
                    <div>
                        <label className={classes.label}>Password</label> <br></br>
                        <input type='password' className={classes.input} required id='password' ref={passRef}/>
                    </div>
                    <div>
                        {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
                        <input type='submit' className={classes.myButton} value='Sign in'></input>
                    </div>
                </form>
                <div>
                    <span className={classes.span}>Don't have an account?</span>
                    <button className={classes.link} onClick={props.onClick}> Sign up!</button>
                </div>
                <div>
                    <span className={classes.span}>Forgot password? </span>
                    <Link className={classes.link2} to='/forgot-password'>Click here!</Link>
                </div>
            </div>
            <div className={classes.right}>
                    <img src={Logo} className={classes.image2}/>
                    <h3 className={classes.second}>WORKHORSE</h3>
            </div>
            
            
        </div>
    );
}

export default withRouter(Login2);